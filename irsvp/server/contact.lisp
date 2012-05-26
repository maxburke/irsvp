(in-package :irsvp)

(defmacro null-or-empty (str)
 `(or (null ,str) (string= ,str "")))

(defun contact-handle-post ()
 (let* ((raw-json-string (octets-to-string (raw-post-data :request *request*) :external-format :utf8))
        (json-string (if (null-or-empty raw-json-string)
                         nil
                         (decode-json-from-string raw-json-string)))
        (email (cdr (assoc :email json-string)))
        (name (cdr (assoc :name json-string)))
        (content (cdr (assoc :content json-string))))
  (if (not (or (null-or-empty email) (null-or-empty content)))
   (let ((emails `(,email "maxburke@gmail.com")))
    (cl-smtp:send-email "smtp.gmail.com"
                           email
                           "inbox@irsvp.cc"
                           (format nil "[iRSVP] Contact Request from ~a (~a)" name email)
                           content
                           :ssl :tls
                           :authentication '(:login "inbox@irsvp.cc" "W0zixege")
                           :cc "maxburke@gmail.com")
     *successful-login-response*
    )
   )
  )
)

(defun contact-handler ()
 (let ((req (request-method* *request*)))
  (cond ((eq req :get) (handle-static-file #p"static/contact.html"))
        ((eq req :post) (contact-handle-post)))
 )
)

