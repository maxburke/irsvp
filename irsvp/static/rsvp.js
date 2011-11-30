function invalidRsvp(xhr, errorString, exception) {
    if (xhr.statusCode === 404) {
        // The rsvp code was invalid.
    }
}

function confirmedRsvp(json) {
    $('#rsvp-email').val(json.email);
    $('#rsvp-number').val(json.numGuests);
    $('#rsvp-special').val(json.special);
    $('#rsvp-details').addClass('validated');
    $('#rsvp-confirm').addClass('hidden');
}

function init() {
    $('#rsvp-submit').click(function() {
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
    });
}

