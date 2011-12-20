function logoutError() {
    window.location = "/500";
}

function logoutSuccess() {
    window.location = "/";
}

function logout() {
    var ajaxRequest = {
        url : '/sessions',
        type : 'DELETE',
        dataType : 'json',
        data : '',
        processData : false,
        success : logoutSuccess,
        error : logoutError
    };
    $.ajax(ajaxRequest);
}

