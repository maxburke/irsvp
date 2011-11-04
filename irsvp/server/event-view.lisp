(in-package :irsvp)

(defun event-view (uri)
 (if (null *session*)
  (redirect "/"))
 
 (if (null (cadr uri))
  (redirect "/"))

 (let ((event-id (parse-integer (cadr uri) :junk-allowed t))
       (user-id (session-value 'id *session*)))
  (if (not (event-validate-for-user event-id user-id))
   (redirect "/"))

  (with-html-output-to-string (html-stream)
  )
 )
)
