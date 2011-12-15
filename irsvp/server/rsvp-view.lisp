(in-package :irsvp)

(defvar *invalid-rsvp* (json:encode-json-to-string '((:valid . "false"))))
(defun rsvp-view-handle-get (rsvp-code)
 (with-connection *db-connection-parameters*
  (let* ((lowercase-code (string-downcase rsvp-code))
         (invite-query (select-dao 'invite (:= 'code lowercase-code)))
         (invite (car invite-query)))

   ; Check to make sure that there is an invite in the system with the 
   ; provided rsvp code.
   (if (null invite-query)
    (progn (setf (return-code*) +http-not-found+)
     *invalid-rsvp*)
    (json:encode-json-to-string invite)
   )
  )
 )
)

(defun rsvp-view-handle-put (rsvp-code)
)

(defun rsvp-view-process-rsvp (rsvp-code method)
 (cond ((eq method :get) (rsvp-view-handle-get rsvp-code))
       ((eq method :put) (rsvp-view-handle-put rsvp-code))
 )
)

(defun rsvp-view (uri)
 (let* ((rsvp-code (caddr uri)))
  (if (or (null rsvp-code) (string= rsvp-code ""))
   (html-404-handler)
   (rsvp-view-process-rsvp rsvp-code (request-method* *request*)))
 )
)
