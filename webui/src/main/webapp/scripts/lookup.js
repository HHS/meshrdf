(function() {
    'use strict';

    $(document).ready(function() {
    	var $descForm = $('#descriptor form');
        var $descResults = $('#descriptor .results');
        var $descSpinner = $('#descriptor .spinner');

    	$descForm.find("input[name=label]").autocomplete({
    		minLength: 3,
            open: function(ev, ui) {
                $descResults.empty();
                $descSpinner.html(Handlebars.templates.ringSpinner());
            },
            select: function(ev, ui) {
                $descForm.trigger('submit');
            },
    		source: function(request, callback) {
    			$.ajax({
    			    url: $descForm.attr('action'),
    			    type: "get",
    			    dataType: "json",
    			    data: {
    			        match: "startswith",
    			        label: request.term,
                        limit: 20,
    			    },
    			    success: function(response) {
                        $descSpinner.empty();
                        if (response.length == 0) {
                            var htmlText = Handlebars.templates.lookupNoMatch();
                            $descResults.html(htmlText);
                        }
                        callback(response.map(function(r) {
                            return r.label;
                        }));

                    },
                    error: function(xhr) {
                        $descSpinner.empty();
                        console.log(xhr);
                    }
    			});
    		}
    	});

    	$descForm.on('reset', function (ev) {
    	    console.log("form is reset");
            $descResults.empty();
            $descSpinner.empty();
    	});

    	$descForm.submit(function (ev) {
    	    console.log("form is submit");
            $descResults.empty();
            $descSpinner.html(Handlebars.templates.ringSpinner());
            ev.preventDefault();
            var labelValue = $descForm.find("input[name=label]").val();
            $.ajax({
                url: $descForm.attr('action'),
                type: "get",
                dataType: "json",
                data: {
                    match: "exact",
                    label: labelValue,
                },
                success: function(response) {
                    // double check that there are matches
                    var htmlText;
                    if (response.length == 0) {
                        htmlText = Handlebars.templates.lookupNoMatch();
                        $descResults.html(htmlText);
                        $descSpinner.empty();
                    } else {
                        var resource = response[0].resource;
                        htmlText = Handlebars.templates.lookupResults({result: response});
                        $descResults.html(htmlText);

                        /* Load the qualifiers, see also, and terms */
                        $.ajax({
                            url: "/mesh/lookup/details/",
                            data: {
                                "descriptor": resource
                            },
                            success: function(response) {
                                $descSpinner.empty();
                                console.log("details response");
                                console.log(response);
                                if (response.seealso.length > 0) {
                                    var seealsoText = Handlebars.templates.descSeeAlso(response);
                                    $descResults.find('#seealso').html(seealsoText);
                                }

                                if (response.terms.length > 0) {
                                    var termsText = Handlebars.templates.descTerms(response);
                                    $descResults.find('#terms').html(termsText);
                                }
                                if (response.qualifiers.length > 0) {
                                    var qualText = Handlebars.templates.descQualifiers(response);
                                    $descResults.find('#qual').html(qualText);
                                }
                            },
                            error: function(xhr) {
                                $descSpinner.empty();
                                console.log(xhr);
                            }

                        });
                    }
                },
                error: function(xhr) {
                    console.log("error response");
                    console.log(xhr);
                    // label is required...
                }
            });
        });

    	var $pairForm = $('#pair form');
        var $pairResults = $('#pair .results');
        var $pairSpinner = $('#pair .spinner');

        $pairForm.find('input[name=descriptor_label]').autocomplete({
            minLength: 3,
            open: function(ev, ui) {
                $pairSpinner.html(Handlebars.templates.ringSpinner());
                $pairForm.find('input[name=label]').attr('disabled', true);
            },
            select: function(ev, ui) {
                $pairForm.find('input[name=label]').removeAttr('disabled').focus();
            },
            source: function(request, callback) {
                $.ajax({
                    url: $descForm.attr('action'),
                    type: "get",
                    dataType: "json",
                    data: {
                        match: "startswith",
                        label: request.term,
                        limit: 20,
                    },
                    success: function(response) {
                        $pairSpinner.empty();
                        if (response.length == 0) {
                            var htmlText = Handlebars.templates.lookupNoMatch();
                            $pairResults.html(htmlText);
                        }
                        callback(response.map(function(r) {
                            return r.label;
                        }));

                    },
                    error: function(xhr) {
                        console.log(xhr);
                        $pairSpinner.empty();
                    }
                });
            }
        });
        $pairForm.on('reset', function(ev) {
            $pairForm.find('input[name=label]').attr('disabled', true);
            $pairResults.empty();
            $pairSpinner.empty();
        });
        $pairForm.submit(function (ev) {
            console.log("pair form submission");
            ev.preventDefault();
            $pairResults.html('<div class="alert alert-warn">Not yet implemented</div>');
            $pairSpinner.empty();
        });

        $("#lookupTabs a:first").tab('show');
    });
})();
