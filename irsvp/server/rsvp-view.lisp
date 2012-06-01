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
 (let* ((lowercase-code (string-downcase rsvp-code))
        (raw-json-string (octets-to-string (raw-post-data :request *request*) :external-format :utf8))
        (json-string (if (null-or-empty raw-json-string)
                         nil
                         (decode-json-from-string raw-json-string)))
        (email (cdr (assoc :email json-string)))
        (attendance (cdr (assoc :attendance json-string)))
        (requests (cdr (assoc :special json-string))))
  (when (null json-string)
   (return-from rsvp-view-handle-put *invalid-rsvp*))

  (with-connection *db-connection-parameters*
   (let* ((invite-query (select-dao 'invite (:= 'code lowercase-code)))
          (invite (car invite-query)))
    (setf (invite-email invite) email)
    (setf (invite-special invite) requests)
    (setf (invite-responded invite) attendance)
    (update-dao invite)))
  *successful-login-response*
 )
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
