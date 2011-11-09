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

(defun rematerialize-object-from-post-data ()
 (let* ((json-string (octets-to-string (raw-post-data :request *request*) :external-format :utf8)))
  (decode-json-from-string json-string)
 )
)

(defun invite-view-handle-put (invite-id)
 (let ((invite (rematerialize-object-from-post-data)))
  (invite-controller-handle-update invite-id invite)
 )
)

(defun invite-view-handle-post (event-id)
 (let* ((invite (rematerialize-object-from-post-data))
        (last-name (cdr (assoc :last-name invite)))
        (first-name (cdr (assoc :first-name invite)))
        (email (cdr (assoc :email invite))))
  (invite-controller-create event-id email first-name last-name)
 )
)

(defun invite-delete (invite-id)
 (if invite-id
  (let ((invite (select-dao 'invite (:= 'id invite-id))))
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
        ((eq req :delete) (invite-delete invite-id))
        (t (server-log "Unknown HTTP method!")))
 )
)
