(function() {
  'use strict';

  function updateState(state) {
    var queryString = '?'+Object.keys(state).map(function(key) { return key+'='+state[key]; }).join('&');
    history.pushState(state, '', queryString);
  }

  function mergeState(newState) {
    var state = Object.assign({}, history.state);
    Object.assign(state, newState);
    var queryString = '?'+Object.keys(state).map(function(key) { return key+'='+state[key]; }).join('&');
    history.pushState(state, '', queryString);
  }

  $(document).ready(function() {
    var autocompleteDataKey = 'mrdfAuto';
    var descriptorKey = 'mrdfDescriptor';
    var submitDataKey = 'mrdfSubmit';

    var $descForm = $('#descriptor form');
    var $descResults = $('#descriptor .results');
    var $descSpinner = $('#descriptor .spinner');

    function handlerFor($spinner, $results) {
      return function(xhr) {
        $spinner.empty();
        if (xhr.status == 400) {
          console.log(xhr.responseJSON);
        } else {
          console.log(xhr.status, xhr.responseText);
        }
      };
    }

    $descForm.find('input[name=label]').autocomplete({
      minLength: 4,
      open: function(ev, ui) {
        $descResults.empty();
      },
      select: function(ev, ui) {
        $descForm.data(descriptorKey, ui.item);
        $descForm.trigger('submit');
      },
      source: function(request, callback) {
        $descForm.removeData(autocompleteDataKey);
        $descSpinner.html(Handlebars.templates.ringSpinner());
        $.ajax({
          url: $descForm.attr('action'),
          data: {
            match: "startswith",
            label: request.term,
            limit: 20,
          },
          success: function(response) {
            $descForm.data(autocompleteDataKey, response);
            $descSpinner.empty();
            if (response.length == 0) {
              var htmlText = Handlebars.templates.lookupNoMatch();
              $descResults.html(htmlText);
            } else {
              callback(response);
            }
          },
          error: handlerFor($descSpinner, $descResults),
        });
      }
    });

    $descForm.on('reset', function (ev) {
      $descResults.empty();
      $descSpinner.empty();
      $descForm.removeData([autocompleteDataKey, descriptorKey, submitDataKey]);
    });

    /* Load the qualifiers, see also, and terms */
    var lookupDetails = function(resource) {
      $descForm.removeData(submitDataKey);
      $.ajax({
        url: '/mesh/lookup/details',
        data: {
          descriptor: resource
        },
        success: function(response) {
          $descSpinner.empty();
          $descForm.data(submitDataKey, response);
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
        error: handlerFor($descSpinner, $descResults),
      });
    };

    var lookupDescriptorExact = function(label) {
      $.ajax({
        url: $descForm.attr('action'),
        data: {
          match: 'exact',
          label: label,
        },
        success: function(response) {
          // double check that there are matches
          var htmlText;          
          if (response.length == 0) {
            htmlText = Handlebars.templates.lookupNoMatch();
            $descResults.html(htmlText);
            $descSpinner.empty();
          } else {
            $descForm.data(descriptorKey, response[0]);
            htmlText = Handlebars.templates.lookupResults({result: response});
            $descResults.html(htmlText);
            lookupDetails(response[0].resource);
          }
        },
        error: handlerFor($descSpinner, $descResults),
      });
    };

    $descForm.submit(function (ev) {
      $descResults.empty();
      $descSpinner.html(Handlebars.templates.ringSpinner());
      $descForm.removeData(submitDataKey);
      ev.preventDefault();
      var labelValue = $descForm.find("input[name=label]").val();
      mergeState({label: labelValue});
      lookupDescriptorExact(labelValue);
    });

    var $pairForm = $('#pair form');
    var $pairResults = $('#pair .results');
    var $pairSpinner = $('#pair .spinner');

    $pairForm.find('input[name=descriptor_label]').autocomplete({
      minLength: 4,
      open: function(ev, ui) {
        $pairForm.find('input[name=label]').attr('disabled', true);
      },
      select: function(ev, ui) {
        $pairSpinner.empty();
        $pairForm.data(descriptorKey, ui.item);
        $pairForm.find('input[name=label]').removeAttr('disabled').focus().autocomplete('search', '');
        $pairResults.empty();
      },
      source: function(request, callback) {
        $pairForm.removeData(autocompleteDataKey);
        $.ajax({
          url: $descForm.attr('action'),
          data: {
            match: 'startswith',
            label: request.term,
            limit: 20,
          },
          success: function(response) {
            $pairForm.data(autocompleteDataKey, response);
            $pairSpinner.empty();
            if (response.length == 0) {
              var htmlText = Handlebars.templates.lookupNoMatch();
              $pairResults.html(htmlText);
            }
            callback(response);
          },
          error: handlerFor($pairSpinner, $pairResults),
        });
      }
    });

    $pairForm.find('input[name=label]').autocomplete({
      minLength: 0,
      open: function(ev, ui) {
        $pairSpinner.html(Handlebars.templates.ringSpinner());
      },
      select: function(ev, ui) {
        $pairSpinner.empty();
        $pairForm.trigger('submit');
      },
      source: function(request, callback) {
        $pairSpinner.html(Handlebars.templates.ringSpinner());
        $.ajax({
          url: '/mesh/lookup/qualifiers/',
          data: {
            descriptor: $pairForm.data(descriptorKey).resource
          },
          success: function(response) {
            $pairSpinner.empty();
            $pairForm.data(autocompleteDataKey, response);
            callback(response);
          },
          error: handlerFor($pairSpinner, $pairResults),
        });
      }
    });
    $pairForm.on('reset', function(ev) {
      $pairForm.find('input[name=label]').attr('disabled', true);
      $pairResults.empty();
      $pairSpinner.empty();
      $pairForm.removeData([autocompleteDataKey, descriptorKey, submitDataKey]);
    });
    $pairForm.submit(function (ev) {
      ev.preventDefault();
      $pairSpinner.html(Handlebars.templates.ringSpinner());
      var qualifierLabel = $pairForm.find('input[name=label]').val();
      var descriptorLabel = $pairForm.find('input[name=descriptor_label]').val();
      var descriptor = $pairForm.data(descriptorKey);
      if (descriptor && descriptorLabel === descriptor.label) {
        $.ajax({
          url: $pairForm.attr('action'),
          data: {
            descriptor: descriptor.resource,
            label: qualifierLabel,
          },
          success: function(response) {
            $pairSpinner.empty();
            var htmlText;
            if (response.length == 0) {
              htmlText = Handlebars.templates.lookupNoMatch();
              $pairResults.html(htmlText);
            } else {
              $pairForm.data(descriptorKey, response[0]);
              htmlText = Handlebars.templates.lookupResults({result: response});
              $pairResults.html(htmlText);
            }
          },
          error: handlerFor($pairSpinner, $pairResults),
        });
      }
    });

    $('#lookupTabs a[data-toggle="tab"]').on('shown.bs.tab', function() {
      var formName = this.getAttribute("href").substring(1);
      updateState({'form': formName});
    });

    var params = new URLSearchParams(window.location.search);
    var initialForm = params.get('form');
    if (initialForm !== 'descriptor' && initialForm !== 'pair') {
      initialForm = 'descriptor';
    }  
    $('#lookupTabs a[href="#'+initialForm+'"]').click();
   
    if (initialForm == 'descriptor') {
      var label = params.get('label');
      if (label !== null && label !== '') {
        $descForm.find('input[name=label]').val(label);
        $descForm.trigger('submit');
      }
    }
  });
})();
