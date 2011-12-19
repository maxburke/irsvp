newMember = false;

function showJoinForm() {
    $('#confirm-password-input').show();
    $('#new').hide();
    $('#submit').text('Join!');
    newMember = true;
}

function submit() {
    var ajaxRequest = {
        url : documentUrl,
        type : "POST",
        dataType : "json",
        success : confirmedRsvp
    };
    $.ajax(ajaxRequest)
}

function init() {
    $('#new').click(showJoinForm);
    $('#submit').click(submit);
}
