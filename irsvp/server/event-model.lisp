(in-package :irsvp)
    
(defclass event ()
 ((id :col-type serial :initarg :id :reader event-id)
  (user-id :col-type :integer :initarg :user-id :accessor event-user-id)
  (name :col-type string :initarg :name :accessor event-name))
 (:metaclass dao-class)
 (:keys id)
)

(deftable event
 (!dao-def)
 (!foreign 'users 'user-id :on-delete :no-action :on-update :no-action)
)

(defun event-initialize ()
 (with-connection *db-connection-parameters*
  (ignore-errors
   (execute (:drop-table 'event)))

  (create-table 'event)
 )
)

