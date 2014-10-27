/*(function($) {
    $(window).load(function() {
        // Control the size of the RDF graph images.  Usually 75% is just about right,
        // but the max allowed will be 800px
        $('img.rdf-graph').each(function() {
          var old_width = $(this).width();
          var nice_width = old_width * 0.75;
          $(this).width(nice_width > 800 ? 800 : nice_width);
        });
    });
})(jQuery);
*/