(in-package :irsvp)

(defclass invite ()
 ((id :col-type serial :initarg :id :reader invite-id)
  (event-id :col-type :integer :initarg event-id :accessor invite-event-id)
  (last-name :col-type string :initarg :last-name :accessor invite-last-name)
  (first-name :col-type string :initarg :first-name :accessor invite-first-name)
  (code :col-type string :initarg :first-name :accessor invite-code)
  (email :col-type string :initarg :email :accessor invite-email)
  (special :col-type string :initarg :special :accessor invite-special))
 (:metaclass dao-class)
 (:keys id)
)

(deftable invite
 (!dao-def)
 (!foreign 'event 'event-id 'id :on-delete :no-action :on-update :no-action)
)

(defun invite-initialize ()
 (with-connection *db-connection-parameters*
  (ignore-errors
   (execute (:drop-table 'invite)))

  (create-table 'invite)
 )
)

