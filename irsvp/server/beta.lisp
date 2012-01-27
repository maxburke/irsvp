(in-package :irsvp)

(cl-smtp:send-email "smtp.gmail.com" "inbox@irsvp.cc" "maxburke@gmail.com" "Welcome to iRSVP!" "Welcome to iRSVP! We are in beta." :ssl :tls :authentication '(:login "inbox@irsvp.cc" "W0zixege"))

(defun beta-handler ()
 (let* ((raw-json-string (octets-to-string (raw-post-data :request *request*) :external-format :utf8))
        (json-string (if (or (null raw-json-string) (string= raw-json-string ""))
                          nil
                          (decode-json-from-string raw-json-string)))
        (email (cdr (assoc :email json-string))))
  (when (and (not (null email))
             (position #\@ email))
        (cl-smtp:send-email "smtp.gmail.com"
                            "inbox@irsvp.cc"
                            email
                            "Welcome to iRSVP!"
                            (format nil "Welcome to iRSVP!~%~%We're glad to hear you're interested in our service! Since we're in beta we are working hard to bring you the best experience we can. We'll get back to you shortly with more details on our service and how you can using it! Feel free to contact us at inbox@irsvp.cc with any questions you have! ~%~%Cheers,~%-Max Burke~%iRSVP.cc")
                            :ssl :tls
                            :authentication '(:login "inbox@irsvp.cc" "W0zixege")
                            :cc "inbox@irsvp.cc")
        (cl-smtp:send-email "smtp.gmail.com"
                            "inbox@irsvp.cc"
                            "maxburke@gmail.com"
                            "New iRSVP interest!"
                            (format nil "The user '~a' is expressing interest in iRSVP. Follow up!" email)
                            :ssl :tls
                            :authentication '(:login "inbox@irsvp.cc" "W0zixege"))
  )
  *successful-login-response*
 )
)

