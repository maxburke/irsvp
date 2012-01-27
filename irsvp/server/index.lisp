(in-package :irsvp)

(defun index-handler ()
 (if *session*
  (redirect "/home")
  (handle-static-file #p"static/index.html")
 )
)

