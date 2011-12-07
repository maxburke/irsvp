(in-package :irsvp)

(defun index-handler ()
 (with-html-output-to-string (html-stream)
  (with-header html-stream
   (:h1 "hello world!")
  )
 )
)


