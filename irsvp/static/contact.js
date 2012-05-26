// Copyright (c) irsvp.cc

function init() {
    $('#submit').click(function() {
        if ($('#email').val() !== '' && $('content').val() !== '') {
            $('#submit').attr('disabled', true);
            var request = {
                url : '/contact',
                type : 'POST',
                data : JSON.stringify({ 
                    email : $('#email').val(),
                    name : $('#name').val(),
                    content : $('#content').val() }),
                dataType : 'json',
                processData : false,
                success : function () {
                    $('.actions').hide();
                    $('#response').append("<center>Thank you for your interest, "
                        + "we will get back to you shortly!</center>");
                }
            };
            $.ajax(request);
        }
    });
}

