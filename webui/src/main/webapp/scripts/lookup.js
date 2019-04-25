(function() {
    'use strict';

    $(document).ready(function() {
    	const $descform = $('#descriptor form');
    	$descform.find("input[name=label]").autocomplete({
    		minLength: 3,
    		source: function(request, callback) {
    			$.ajax({
    			    url: $descform.attr('action'),
    			    type: "get",
    			    dataType: "json",
    			    data: {
    			        match: "startswith",
    			        label: request.term,
    			    },
    			    success: function(response) {
    			        callback(response.map(r => r.label));
    			    },
    			});
    		}
    	});

    	$descform.on('reset', function (ev) {
    	    console.log("form is reset");
    	});

    	$descform.submit(function (ev) {
    	    console.log("form is submit");
            ev.preventDefault();
            const labelValue = $descform.find("input[name=label]").val();
            $.ajax({
                url: $descform.attr('action'),
                type: "get",
                dataType: "json",
                data: {
                    match: "exact",
                    label: labelValue
                },
                success: function(response) {
                    // double check that there are matches
                    console.log("results");
                    console.log(response);
                    const htmlText = Handlebars.templates.lookupResults({result: response});
                    $('#descriptor .results').html(htmlText);
                },
                error: function(xhr) {
                    console.log("error response");
                    console.log(xhr);

                    // label is required...
                }
            });
        });

    	const $pairform = $('#pair form');
        $pairform.submit(function (ev) {
        	$.ajax ()
        });

        $("#lookupTabs a:first").tab('show');
    });
})();
