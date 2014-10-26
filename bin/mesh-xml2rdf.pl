#! /usr/bin/env perl

# The aim of this script is to provide a means to run the XSLTs against the very huge MeSH XML
# files, on machines that have limited memory.  For each of the inputs qual, desc, and supp, it will
#   * split the input XML into chunks
#   * run each chunk through the XSLT, producing a chunk of RDF in n-triples format
#   * (TBD) concatenate those n-triples together.
# The last step is "TBD", because it might turn out to be easier to load the triples into a triple
# store if they remain in manageable chunk sizes.
#
# Before running this, make sure you have two environment variables set:
#   - MESHRDF_HOME should point to the directory where the the work will be done.
#     The `data` subdirectory is assumed to hold the source XML files, and the output
#     files will be written to `out`.
#   - SAXON_JAR should point to the saxon jar file.
# Finally, make sure that your current directory is the hhs/meshrdf repository directory, as this
# script refers to the XSLT files in the xslt directory by their relative paths.

use strict;

my $LINES_PER_CHUNK = 500000;
my $meshrdf_home = $ENV{MESHRDF_HOME};
my $saxon_jar = $ENV{SAXON_JAR};
if (!$meshrdf_home || !$saxon_jar) {
    die "You must first define the environment variables MESHRDF_HOME and SAXON_JAR.";
}
my $out_dir = "$meshrdf_home/out";
mkdir $out_dir;    # if it didn't exist already

my @sets = qw( qual desc supp );

# First, chunk up the XML
foreach my $set (@sets) {
    my $xml_file = "$meshrdf_home/data/$set" . "2014.xml";
    my $xml_chunk_base = "$out_dir/$set-";

    my $state = 0;   # init
    open( my $XML_FILE, '<' , $xml_file ) or die( "Can't open $xml_file for reading ($!)" );
    print "Chunking $set\n";

    my $wrapper_line;
    my $wrapper_element_name;
    my $chunk_num = 0;
    my $item_element_name;
    my $CHUNK_FILE;
    my $chunk_line_num;
    while (my $line = <$XML_FILE>) {
        chomp $line;

        # Initial state
        if ($state == 0) {
            if ($line =~ /^\<(\w+) /) {
                $wrapper_element_name = $1;
                $wrapper_line = $line;
                #print "wrapper_line = '$wrapper_line'; wrapper_element_name = '$wrapper_element_name'\n";
                $state = 1;    # Ready to start the first chunk file
            }
        }

        # Ready to start a new chunk.  $CHUNK_FILE is not open.
        elsif ($state == 1) {
            #print "state == 1, line is '$line'\n";
            # If we see the closing tag of the whole file, just get out
            if ($line =~ /^\s*\<\/$wrapper_element_name\>/) {
                $state = 3;
            }
            if ($line =~ /^\<(\w+) /) {
                $item_element_name = $1;
                my $chunk_file = $xml_chunk_base . sprintf("%03d", $chunk_num) . '.xml';
                $chunk_num++;
                open($CHUNK_FILE, ">", $chunk_file) or die("Can't open $chunk_file for writing ($!)");
                print "  Writing $chunk_file\n";
                print $CHUNK_FILE $wrapper_line . "\n";
                print $CHUNK_FILE $line . "\n";
                $chunk_line_num = 0;
                $state = 2;    # Writing chunk
            }
        }

        # Writing chunk
        elsif ($state == 2) {
            print $CHUNK_FILE $line . "\n";
            $chunk_line_num++;
            # If we see the closing tag of the whole file
            if ($line =~ /^\s*\<\/$wrapper_element_name\>/) {
                close $CHUNK_FILE;
                $state = 3;    # Done
            }
            # Otherwise, if we are outside the min. lines per chunk, and we see the closing tag of
            # an item, then close this chunk and get ready to start a new one.
            elsif ($chunk_line_num > $LINES_PER_CHUNK &&
                $line =~ /^\s*\<\/$item_element_name\>/)
            {
                print $CHUNK_FILE "</$wrapper_element_name>\n";
                close $CHUNK_FILE;
                $state = 1;    # Ready for next chunk
            }
        }

        elsif ($state == 3) {
            last;
        }
    }
    close $xml_file;
    print "$xml_file split into $chunk_num chunks\n";
}

# Next, run the transforms
foreach my $set (@sets) {
    foreach my $xml_chunk_file (<$out_dir/$set-*.xml>) {
        $xml_chunk_file =~ /-(\d+)/;
        my $num_str = $1;
        my $nt_chunk_file = "$out_dir/$set-$num_str.nt";
        print "Converting $xml_chunk_file -> $nt_chunk_file\n";
        my $cmd = "java -Xmx2G -jar $saxon_jar -s:$xml_chunk_file -xsl:xslt/$set.xsl > $nt_chunk_file";
        print "Executing '$cmd'\n";
        system $cmd;
    }
}
