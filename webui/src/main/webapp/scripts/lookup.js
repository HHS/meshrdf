(function() {
    'use strict';
    
    $(document).ready(function() {
    	const $descform = $('#descriptor form');
    	$descform.find("input[name=label]").autocomplete({
    		minLength: 3,
    		source: function(request, response) {
    			$.getJSON
    			
    		}
    	});

    	$descform.submit(function (ev) {
            ev.preventDefault();
        });
    	
    	const $pairform = $('#pair form');       
        $pairform.submit(function (ev) {
        	$.ajax ()
        });

        $("#lookupTabs a:first").tab('show');
    });
})();
