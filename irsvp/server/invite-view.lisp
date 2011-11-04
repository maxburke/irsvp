(in-package :irsvp)

(defun invite-view-handle-get (event-id invite-id)
 (with-connection *db-connection-parameters*
  (json:encode-json-to-string
   (if invite-id
    (select-dao 'invite (:= 'id invite-id))
    (select-dao 'invite (:= 'event-id event-id) 'id))
  )
 )
)

(defun invite-view-handle-put (invite-id)
)

(defun invite-view-handle-post (event-id)
)

(defun process-invite-delete (invite-id)
 (if invite-id
  (let ((invite (select-dao 'invite (:= id invite-id))))
   (if invite (delete-dao invite))
  )
 )
)

; /invite/<event id>/<invite id>
(defun invite-view (uri)
 (if (null *session*)
  (redirect "/"))

 (if (null (cadr uri))
  (redirect "/"))

 (let* ((event-id (parse-integer (cadr uri) :junk-allowed t))
        (raw-invite-id (caddr uri))
        (invite-id (if raw-invite-id (parse-integer raw-invite-id :junk-allowed t) nil))
        (req (request-method* *request*)))
  (cond ((eq req :get) (invite-view-handle-get event-id invite-id))
        ((eq req :put) (invite-view-handle-put invite-id))
        ((eq req :post) (invite-view-handle-post event-id))
        ((eq req :delete) (process-invite-delete invite-id))
        (t (server-log "Unknown HTTP method!")))
 )
)
