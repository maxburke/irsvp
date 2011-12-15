function errorCallback(xhr, errorString, exception) {
    if (xhr.status === 401) {
        window.location = "/login";
    }
}

function fillOutEventList(json) {
    var html = '<ul>';
    for (var i = 0; i < json.length; ++i) {
        var item = json[i];

        html += '<li><a href="/events/' + item.id + '">'
            + item.name
            + '</a></li>';
    }
    html += '</ul>';
    $('#events-list').html(html);
}

function successCallback(json) {
    if (json.length > 0)
        return fillOutEventList(json);

}

function init() {
    var documentUrl = "/data/home";
    var ajaxRequest = {
        url : documentUrl,
        type : "GET",
        dataType : "json",
        error : errorCallback,
        success : successCallback
    };
    $.ajax(ajaxRequest);
}

