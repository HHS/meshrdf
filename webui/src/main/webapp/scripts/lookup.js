(function() {
    'use strict';
    $(document).ready(function() {
        /* Register callbacks on the content if needed */
        $('#descriptor form').submit(function (ev) {
            var mockResults = {
                result: [
                    {
                        label: "Foo", resource: "http://id.nlm.nih.gov/mesh/D01"
                    },
                    {
                        label: "Bar", resource: "http://id.nlm.nih.gov/mesh/D02"
                    }
                ]
            };
            var html_text = Handlebars.templates.lookupResults(mockResults);
            $('#descriptor .results').html(html_text);
            ev.preventDefault();
        });
        $("#lookupTabs a:first").tab('show');
    });
})();
