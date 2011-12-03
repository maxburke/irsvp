function invalidRsvp(xhr, errorString, exception) {
    if (xhr.statusCode === 404) {
        // The rsvp code was invalid.
    }
}

function confirmedRsvp(json) {
    $('#rsvp-email').val(json.email);
    var selectionDropdown = 'I <select id="rsvp-number-box">'
        + '<option value="0">will not be coming :(</option>'
        + '<option value="1">will be coming!</option>';
    for (var i = 1; i < json.numGuests; ++i) {
        selectionDropdown += '<option value="' 
            + (i + 1) 
            + '">will be coming with ' 
            + i + ' guest' 
            + (i > 1 ? 's' : '')
            + '</option>';
    }
    selectionDropdown += '</select>';
    $('#rsvp-number').html(selectionDropdown);
    $('#rsvp-special').val(json.special);
    $('#rsvp-details').addClass('validated');
    $('#rsvp-confirm').addClass('hidden');
}

function handleSubmit() {
    var urlEndIndex = document.URL.length - 1;
    var documentUrl = document.URL;
    if (documentUrl[urlEndIndex] != "/") {
        documentUrl = documentUrl + "/";
    }
    documentUrl = documentUrl + $('#rsvp-code').val();
    var ajaxRequest = {
        url : documentUrl,
        type : "GET",
        dataType : "json",
        error : invalidRsvp,
        success : confirmedRsvp
    };
    $.ajax(ajaxRequest)
}

function init() {
    $('#rsvp-code').keypress(function(event) {
        if (event.which === 13) {
            handleSubmit();
        }
    });
    $('#rsvp-submit').click(handleSubmit);
}

