(in-package :irsvp)

(defun index-handler ()
 (if *session*
  (handle-static-file #p"static/index-logged-in.html")
  (handle-static-file #p"static/index.html")
 )
)

