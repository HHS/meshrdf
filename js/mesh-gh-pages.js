(function($) {
  /*
    // Control the size of the RDF graph images.  Usually 75% is just about right,
    // but the max allowed will be 800px
    $(window).load(function() {
        $('img.rdf-graph').each(function() {
          var old_width = $(this).width();
          var nice_width = old_width * 0.75;
          $(this).width(nice_width > 800 ? 800 : nice_width);
        });
    });
  */

  /*
    This function converts a <span class='invoke-sparql'> element in the source into a
    hyperlink that will call the SPARQL engine to produce the results of the query found
    in the sparql code block.  It assumes there's only one sparql code block on the page.
   */
  $(document).ready(function () {
      var sparql_endpoint = 'http://jatspan.org:8890/sparql';
      var sparql_format_param = 'format=text%2Frdf%2Bn3';

      var query_ref = $('.invoke-sparql');
      var query_block = $('.language-sparql');
      var q_enc = encodeURIComponent(query_block.text());
      var endpoint_url = sparql_endpoint + "?query=" + q_enc + '&' + sparql_format_param;
      query_ref.wrap("<a href='" + endpoint_url + "' target='_blank'/>");
  });
})(jQuery);
