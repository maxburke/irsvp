documentUrlBase = '';

function handleSelectionChange(event) {
    if (parseInt($(this).val()) !== -1) {
        $('#attendance-confirmed').html('<img src="/static/icons/check.jpg"/>');
    } else {
        $('#attendance-confirmed').html('<span></span>');
    }
}

function handleEmailKeypress(event) {
    var text = $('#rsvp-email').val();
    var expression = /.+@.+\..+/;
    if (text.search(expression) != -1) {
        $('#email-confirmed').html('<img src="/static/icons/check.jpg"/>');
    } else {
        $('#email-confirmed').html('');
    }
}

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
            + '!</option>';
    }
    $('#rsvp-number-box').html(selectionDropdownText);
    $('#rsvp-number-box').removeAttr('disabled');
    $('#rsvp-number-box').change(handleSelectionChange);

    $('#rsvp-special').text(json.special);
    $('#rsvp-special').removeAttr('disabled');

    $('#rsvp-confirm-submit').removeClass('disabled');

    $('#code-confirmed').html('<img src="/static/icons/check.jpg"/>');
    handleEmailKeypress();
    $('#rsvp-email').keyup(handleEmailKeypress);
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
    documentUrlBase = '/data/rsvp/';
    $('#rsvp-code').keyup(handleRsvpKeypress);
}

