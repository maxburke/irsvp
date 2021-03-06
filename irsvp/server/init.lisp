(in-package :irsvp)

(defmacro variable-dispatcher (content-type content)
  `(lambda ()
    (setf (content-type*) ,content-type)
    ,content))

(defun split-uri-by-slashes (uri)
 (let ((collection '()))
  (labels ((recursive-extract (uri-fragment)
            (if uri-fragment
             (let ((fragment-end (position #\/ uri-fragment)))
              (push (subseq uri-fragment 0 fragment-end) collection)
              (if fragment-end
               (recursive-extract (subseq uri-fragment (1+ fragment-end))))))))
  (recursive-extract (subseq uri (1+ (position #\/ uri)))))
  (nreverse collection)
 )
)

(defmacro uri-dispatcher (fn)
 `(lambda ()
     (let ((uri-components (split-uri-by-slashes (request-uri* *request*))))
      (funcall ,fn uri-components))
  )
)
    
(defun init ()
 (if (not (null *server-instance*))
  (stop *server-instance*))

 (setf *server-instance* 
  (make-instance 'easy-acceptor :port 8000))

 (setf (acceptor-message-log-destination *server-instance*) #p"/home/ubuntu/src/irsvp/logs/message.log")
 (start *server-instance*)

 (setf *dispatch-table*
  (nconc (list 'dispatch-easy-handlers
          (create-folder-dispatcher-and-handler "/static/" #p"static/")
          (create-prefix-dispatcher "/login" 'login-handler)
          (create-prefix-dispatcher "/logout" 'logout-handler)
          (create-prefix-dispatcher "/sessions" 'sessions-handler)
          (create-static-file-dispatcher-and-handler "/favicon.ico" #p"static/favicon.ico")
          (create-static-file-dispatcher-and-handler "/home" #p"static/home.html")
          (create-prefix-dispatcher "/data/home" 'home-view)
          (create-prefix-dispatcher "/data/rsvp" (uri-dispatcher #'rsvp-view))
          (create-prefix-dispatcher "/event" (uri-dispatcher #'event-view))
          (create-prefix-dispatcher "/invite" (uri-dispatcher #'invite-view))
          (create-prefix-dispatcher "/beta" 'beta-handler)
          (create-static-file-dispatcher-and-handler "/rsvp" #p"static/rsvp.html")
          (create-prefix-dispatcher "/contact" 'contact-handler)
          (create-prefix-dispatcher "/" 'index-handler)
          ; TODO:
          ; Add special pages (ie, /500, /404) that have custom error messages for certain conditions.
          'default-dispatcher))))



