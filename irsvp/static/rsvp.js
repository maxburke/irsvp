documentUrlBase = '';

function confirmedRsvp(json) {
    $('#rsvp-email').val(json.email);
    $('#rsvp-email').removeAttr('disabled');

    var numGuests = json.numGuests;
    var selectionDropdownText = 
        '<option value="-1" selected="true"></option>'
        + '<option value="0">will not be coming :(</option>'
        + '<option value="1">will be coming!</option>';
    for (var i = 1; i < numGuests; ++i) {
        selectionDropdownText += '<option value="' 
            + (i + 1) 
            + '">will be coming with ' 
            + i + ' guest' 
            + (i > 1 ? 's' : '')
            + '</option>';
    }
    $('#rsvp-number-box').html(selectionDropdownText);
    $('#rsvp-number-box').removeAttr('disabled');

    $('#rsvp-special').text(json.special);
    $('#rsvp-special').removeAttr('disabled');

    $('#rsvp-confirm-submit').removeClass('disabled');
}

function handleRsvpKeypress(event) {
    var code = escape($('#rsvp-code').val());
    var documentUrl = documentUrlBase + code;
    var ajaxRequest = {
        url : documentUrl,
        type : "GET",
        dataType : "json",
        success : confirmedRsvp
    };
    $.ajax(ajaxRequest)
}

function init() {
    documentUrlBase = '/rsvp/';
    $('#rsvp-code').keyup(handleRsvpKeypress);
}

