(in-package :irsvp)

(defun home-view ()
 (if (null *session*)
  (redirect "/"))

 (with-html-output-to-string (html-stream)
  (:html :xmlns "http://www.w3.org/1999/xhtml"
   (:head)
   (:body
    (:h1 (format html-stream "Welcome, ~a!" (session-value 'email *session*)))
    (let* ((user-id (session-value 'id *session*))
           (events-list (events-fetch user-id)))
     (htm
      (:ul
       (mapcar (lambda (list-entry)
                (let ((event-id (car list-entry))
                      (event-name (cdr list-entry)))
                (with-html-output (html-stream)
                 (:li 
                  (:a :href (write-string (event-get-url event-id))
                   (write-string event-name html-stream)
                   )
                  )
                 ))) events-list)
      )
     )
    )
   )
  )
 )
)
