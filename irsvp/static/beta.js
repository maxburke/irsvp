// Copyright (c) irsvp.cc

function init() {
    $('#submit').click(function() {
        if ($('#email').val() !== '') {
            $('#submit').attr('disabled', true);
            var request = {
                url : '/beta',
                type : 'POST',
                data : JSON.stringify({ email : $('#email').val() }),
                dataType : 'json',
                processData : false,
                success : function () {
                    $('#emailbox').hide();
                    $('#response').append("<center><h4>Thank you for your interest, "
                        + $('#email').val()
                        + "!</h4><p>We will get back to you shortly!</h4></center>");
                }
            };
            $.ajax(request);
        }
    });
}

