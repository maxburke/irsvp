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
 (with-connection *db-connection-parameters*
  (let* ((invite (rematerialize-object-from-post-data))
         (obj (get-dao 'invite (cdr (assoc :id invite)))))
   (assert (equal (invite-event-id obj) (cdr (assoc :event-id invite))))
   (setf (invite-last-name obj) (cdr (assoc :last-name invite)))
   (setf (invite-first-name obj) (cdr (assoc :first-name invite)))
   (setf (invite-email obj) (cdr (assoc :email invite)))
   (setf (invite-special obj) (cdr (assoc :special invite)))
   (setf (invite-responded obj) (cdr (assoc :responded invite)))
   (update-dao obj)
   nil
  )
 )
)

(defun invite-view-handle-post (event-id)
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
