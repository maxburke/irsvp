(in-package :irsvp)

(defun events-fetch (user-id)
 (with-connection *db-connection-parameters*
  (let ((records (select-dao 'event (:= 'user-id user-id)))
        (events-list '()))

   (loop for record in records
    do (push (cons (event-id record) (event-name record)) events-list))

   (nreverse events-list)
  )
 )
)

(defun event-get-url (event-id)
 (concatenate 'string "/events/" (write-to-string event-id))
)

(defun event-get-name (event-id)
 (with-connection *db-connection-parameters*
  (let ((record (select-dao 'event (:= 'id event-id))))
   (if (not (null record))
     (event-name (car record))
    nil)
  )
 )
)

(defun event-validate-for-user (event-id user-id)
 (with-connection *db-connection-parameters*
  (let ((event (select-dao 'event (:= 'id event-id))))
   (if (null event)
    nil
    ; As this function queries on the record ID the result set will
    ; either be empty or contain exactly one record.
    (equal (event-user-id (car event)) user-id)
   )
  )
 )
)

