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

    var guestText = [ '', 'will not be coming :(', 'will be coming!'];
    for (var i = 1; i < numGuests; ++i) {
        guestText[i + 2] = 'will be coming with ' + i + ' guest' + (i > 1 ? 's' : '') + '!';
    }

    var selectionDropdownText = '';
    for (var i = 0; i < guestText.length; ++i) {
        selectionDropdownText += '<option value="' + (i - 1) + '"';
        if (json.responded == (i - 1)) {
            selectionDropdownText += ' selected="true"';
        }
        selectionDropdownText += '>' + guestText[i] + '</option>';
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
    var data
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


function confirmedSubmission(json) {
    $('#rsvp-confirm-submit').hide();
    if (json.success == "true") {
        $('#response').html('<h3>Thank you for confirming!</h3>');
    } else {
        $('#response').html('<h3>It seems that something went wrong. Please <a href="/contact">contact us!</a>"</h3>');
    }
}

function handleRsvpSubmit(event) {
    var submitData = {
        email : $('#rsvp-email').val(),
        attendance : $('#rsvp-number-box').val(),
        special : $('#rsvp-special').val()
    };
    var code = escape($('#rsvp-code').val());
    var documentUrl = documentUrlBase + code;
    var ajaxRequest = {
        url : documentUrl,
        type : "PUT",
        data : JSON.stringify(submitData),
        dataType : "json",
        success : confirmedSubmission
    };
    $.ajax(ajaxRequest);
}

function init() {
    documentUrlBase = '/data/rsvp/';
    $('#rsvp-code').keyup(handleRsvpKeypress);
    $('#rsvp-confirm-submit').click(handleRsvpSubmit);
}

