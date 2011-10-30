(in-package :irsvp)
    
(defprepared valid-password-for-p
 (:select (:= 'password (:crypt '$2 'password)) :from 'users :where (:= '$1 'email)) :single)

(defprepared fetch-user-id
 (:select 'user_id :from 'users :where (:= '$1 'email)) :single)
                                                                                      
(defun login-and-start-session (email)
 (with-connection *db-connection-parameters*
  (let ((session (start-session))
        (user-id (fetch-user-id email)))
   (setf (session-value 'id session) user-id)
   (setf (session-value 'email session) email)
  )
 )
)

(defun login-handler ()
 (setf (content-type*) "text/html")
 (with-connection *db-connection-parameters*
  (let ((password (post-parameter "password"))
        (email (post-parameter "email")))
   (if (valid-password-for-p email password)
    (progn
     (login-and-start-session email)
     ; redirect normally tags the URL with the session ID but this is 
     ; quite ugly, so omit it for now.
     (redirect "/home" :add-session-id nil)
    )
    (with-html-output-to-string (html-stream)
     (:html (:body (:h1 "Login failure!"))))
   )
  )
 )
)

(defun logout-handler ()
 (if *session*
  (progn (delete-session-value 'id)
   (remove-session *session*)))
 (redirect "/")
)


