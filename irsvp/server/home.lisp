(in-package :irsvp)

(defun home-view ()
 (if (null *session*)
  (redirect "/"))

 (with-html-output-to-string (html-stream)
  (:html :xmlns "http://www.w3.org/1999/xhtml"
   (:head)
   (:body
    (:h1 (format html-stream "Welcome, ~a!" (session-value 'email *session*)))
    )
  )
 )
)
