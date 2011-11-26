function confirmCallback(json) {
//    $('#rsvp-details').addClass('validated');
//    $('#rsvp-confirm').addClass('hidden');
}

function init() {
    $('#rsvp-submit').click(function() {
        var urlEndIndex = document.URL.length - 1;
        var documentUrl = document.URL;
        if (documentUrl[urlEndIndex] != "/") {
            documentUrl = documentUrl + "/";
        }
        documentUrl = documentUrl + $('#rsvp-code').val();
//        $.getJSON("", confirmCallback);
    });
}

