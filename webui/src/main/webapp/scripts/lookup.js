(function() {
    'use strict';

    $(document).ready(function() {
    	var $descform = $('#descriptor form');
        var $descresults = $('#descriptor .results');

    	$descform.find("input[name=label]").autocomplete({
    		minLength: 3,
            open: function(ev, ui) {
                $descresults.empty();
            },
            select: function(ev, ui) {
                $descform.trigger('submit');
            },
    		source: function(request, callback) {
    			$.ajax({
    			    url: $descform.attr('action'),
    			    type: "get",
    			    dataType: "json",
    			    data: {
    			        match: "startswith",
    			        label: request.term,
                        limit: 20,
    			    },
    			    success: function(response) {
                        if (response.length == 0) {
                            var htmlText = Handlebars.templates.lookupNoMatch();
                            $descresults.html(htmlText);
                        }
                        callback(response.map(function(r) {
                            return r.label;
                        }));

                    },
                    error: function(xhr) {}
    			});
    		}
    	});

    	$descform.on('reset', function (ev) {
    	    console.log("form is reset");
            $descresults.empty();
            $descform.find(".spinner").empty();
    	});

    	$descform.submit(function (ev) {
    	    console.log("form is submit");
            $descresults.empty();
            ev.preventDefault();
            var labelValue = $descform.find("input[name=label]").val();
            $.ajax({
                url: $descform.attr('action'),
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
                        $descresults.html(htmlText);
                    } else {
                        var resource = response[0].resource;

                        htmlText = Handlebars.templates.lookupResults({result: response});
                        $descresults.html(htmlText);

                        /* Load the qualifiers, see also, and terms */
                        $.ajax({
                            url: "/mesh/lookup/details/",
                            data: {
                                "descriptor": resource
                            },
                            success: function(response) {
                                console.log("details response");
                                console.log(response);
                                if (response.seealso.length > 0) {
                                    var seealsoText = Handlebars.templates.descSeeAlso(response);
                                    $descresults.find('#seealso').html(seealsoText);
                                }

                                if (response.terms.length > 0) {
                                    var termsText = Handlebars.templates.descTerms(response);
                                    $descresults.find('#terms').html(termsText);
                                }
                                if (response.qualifiers.length > 0) {
                                    var qualText = Handlebars.templates.descQualifiers(response);
                                    $descresults.find('#qual').html(htmlText);
                                }

                                /* hide the spinner if both came back*/
                                if (--loadingCount <= 0) {
                                    $descresults.find('.loader').addClass('hidden');
                                }
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

        $pairForm.find('input[name=descriptor_label]').autocomplete({
            minLength: 3,
            open: function(ev, ui) {
                $pairForm.find('.spinner').html(Handlebars.templates.ringSpinner());
                $pairForm.find('input[name=label]').attr('disabled', true);
            },
            select: function(ev, ui) {
                $pairForm.find('input[name=label]').removeAttr('disabled').focus();
            },
            source: function(request, callback) {
                $.ajax({
                    url: $descform.attr('action'),
                    type: "get",
                    dataType: "json",
                    data: {
                        match: "startswith",
                        label: request.term,
                        limit: 20,
                    },
                    success: function(response) {
                        $pairForm.find('.spinner').empty();
                        if (response.length == 0) {
                            var htmlText = Handlebars.templates.lookupNoMatch();
                            $pairresults.html(htmlText);
                        }
                        callback(response.map(function(r) {
                            return r.label;
                        }));

                    },
                    error: function(xhr) {}
                });
            }
        });
        $pairForm.on('reset', function(ev) {
            $pairForm.find('input[name=label]').attr('disabled', true);
            $pairForm.find('.spinner').empty();
            $pairResults.empty();
        });
        $pairForm.submit(function (ev) {
            console.log("pair form submission");
            ev.preventDefault();
            $pairResults.html('<div class="alert alert-warn">Not yet implemented</div>');
        });

        $("#lookupTabs a:first").tab('show');
    });
})();
