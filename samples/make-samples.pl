#! /usr/bin/env perl
# This script will create subsets of the main MeSH XML files, with just a discrete set of
# sample records.  The input XML files are assumed to be in the `data` subdirectory of the
# directory pointed to by the $MESHRDF_HOME environment variable.  The list of records to
# extract are listed in the samples-list.txt file.
#
# This should be run from the samples directory of the repository, and it will overrite the
# *-samples.xml files.
#
# By default, it re-generates all three sample files.  If you want only to regenerate one of
# them, enter "qual", "desc", or "supp" as a command line argument.

use strict;

my $meshrdf_home = $ENV{MESHRDF_HOME};
die "You must first define the environment variables MESHRDF_HOME." if !$meshrdf_home;

my @sets = qw( qual desc supp );

if (@ARGV) {
    my $set = $ARGV[0];
    if (!grep {/$set/} @sets) {
        die "Invalid set; should be one of " . join(", ", @sets);
    }
    @sets = ( $set );
}

my %set_info = (
    'qual' => {
        'id_type_char' => 'Q',
        'sample_list' => [],
        'found' => {},
    },
    'desc' => {
        'id_type_char' => 'D',
        'sample_list' => [],
        'found' => {},
    },
    'supp' => {
        'id_type_char' => 'C',
        'sample_list' => [],
        'found' => {},
    },
);

my $sample_list = 'sample-list.txt';
open(my $SAMPLE_LIST, "<", $sample_list) or die("Can't open $sample_list for input: $!");
while (my $line = <$SAMPLE_LIST>) {
    chomp $line;
    if ($line =~ /^(\w+)/) {
        my $id = $1;
        my $type_char = substr($id, 0, 1);
        print "id = '$id', type_char = '$type_char\n";
        my $found = 0;
        foreach my $set (keys %set_info) {
            my $set_data = $set_info{$set};
            if ($type_char eq $set_data->{id_type_char}) {
                push @{$set_data->{sample_list}}, $id;
                $found = 1;
            }
        }
        if (!$found) {
            die "Unrecognized id type in $sample_list: $id";
        }
    }
}
close $SAMPLE_LIST;


foreach my $set (@sets) {
    my $set_data = $set_info{$set};
    my $sample_list = $set_data->{sample_list};
    my $xml_file = "$meshrdf_home/data/$set" . "2014.xml";
    my $sample_file = "$set-samples.xml";

    my $state = 0;   # init
    open( my $XML_FILE, '<' , $xml_file ) or die( "Can't open $xml_file for reading ($!)" );
    print "Extracting samples from $set\n";

    my $wrapper_element_name;
    my $item_element_name;
    my $SAMPLE_FILE;
    my $line_num = 0;
    while (my $line = <$XML_FILE>) {
        $line_num++;
        chomp $line;

        # Initial state
        if ($state == 0) {
            if ($line =~ /^\<(\w+) /) {
                $wrapper_element_name = $1;
                my $wrapper_line = $line;
                open($SAMPLE_FILE, ">", $sample_file)
                    or die("Can't open $sample_file for writing ($!)");
                # Make sure that on Windows, it only outputs Unix style line-endings
                binmode $SAMPLE_FILE;
                print $SAMPLE_FILE $wrapper_line . "\n";
                $state = 1;    # Ready to start reading items
            }
        }

        # Searching for the start of a sample item.  $SAMPLE_OUT_FILE is open.
        elsif ($state == 1) {
            #print "state == 1, line is '$line'\n";
            # If we see the closing tag of the whole file, just get out
            if ($line =~ /^\s*\<\/$wrapper_element_name\>/) {
                print $SAMPLE_FILE $line . "\n";
                close $SAMPLE_FILE;
                last;
            }
            # If we find the start of an item ...
            if ($line =~ /^\<(\w+) /) {
                $item_element_name = $1;
                # Read the next line
                my $id_line = <$XML_FILE>;
                chomp $id_line;
                $line_num++;
                if ($id_line !~ /<\w+UI>(\w+)<\/\w+UI>/) {
                    die "Couldn't find ID of item at line $line_num";
                }
                my $id = $1;

                if (grep {$_ eq $id} @$sample_list) {
                    print "  found $id\n";
                    $set_data->{found}{$id} = 1;
                    print $SAMPLE_FILE $line . "\n";
                    print $SAMPLE_FILE $id_line . "\n";
                    $state = 2;    # Writing
                }
            }
        }

        # Writing item
        elsif ($state == 2) {
            print $SAMPLE_FILE $line . "\n";
            if ($line =~ /^\s*\<\/$item_element_name\>/)
            {
                $state = 1;    # Ready for next chunk
            }
        }

    }
}

# Check to make sure that all the samples were found

foreach my $set (@sets) {
    my $set_data = $set_info{$set};
    my $sample_list = $set_data->{sample_list};
    my $found = $set_data->{found};

    foreach my $want_id (@$sample_list) {
        print "Checking $want_id\n";
        if (!$found->{$want_id}) {
            print "$want_id not found!\n";
        }
    }
}

