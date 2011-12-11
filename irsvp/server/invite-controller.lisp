(in-package :irsvp)

(defconstant +not-responded+ -1)
(defconstant +no+ 0)

(defvar *code-chars* "0123456789abcdefghijklmnopqrstuv")
(defvar *code-seed* 1918072400) ; FourCC 'rSvP'

;; This function creates the "invite code" which is a base-32 encoded
;; string made by xor'ing the fourCC 'rSvP' with the database id for the
;; actual invite record. The primary key for the invites are used because
;; these values will persist if the server application stops working.
(defun invite-create-code (invite-id)
 (let ((time (get-universal-time))
       (code '())
       (counter))
  (labels ((recursive-create-code (code-base)
            (let ((fragment (logand code-base 31))
                  (remainder (ash code-base -5)))
             (if (not (zerop remainder))
              (progn
               (push (elt *code-chars* fragment) code)
               (recursive-create-code remainder)))
            )))
   (recursive-create-code (logxor *code-seed* (* 16777619 invite-id))))
  (coerce code 'string)
 )
)

(defun invite-status-to-symbol (status)
 (case status
  (+not-responded+ 'not-responded)
  (+no+ 'declined)
  (otherwise 'yes)
 )
)

(defun invite-controller-create (event-id email &optional first-name last-name num-guests)
 (with-connection *db-connection-parameters*
  (let ((new-invite (make-instance 'invite
                     :event-id event-id
                     :email email
                     :last-name (or last-name "")
                     :first-name (or first-name "")
                     :num-guests (or num-guests 1))))
   (insert-dao new-invite)
   ; The invite code can't be calculated until the invite record is created.
   (let* ((id (invite-id new-invite))
          (code (invite-create-code id)))
    (setf (invite-code new-invite) code)
    (save-dao new-invite)
    new-invite)
  )
 )
)

(defun invite-controller-handle-update (invite-id raw-invite)
 (with-connection *db-connection-parameters*
  (let ((obj (get-dao 'invite (cdr (assoc :id raw-invite)))))
   (assert (equal (invite-event-id obj) (cdr (assoc :event-id raw-invite))))
   (setf (invite-last-name obj) (cdr (assoc :last-name raw-invite)))
   (setf (invite-first-name obj) (cdr (assoc :first-name raw-invite)))
   (setf (invite-email obj) (cdr (assoc :email raw-invite)))
   (setf (invite-special obj) (cdr (assoc :special raw-invite)))
   (setf (invite-responded obj) (cdr (assoc :responded raw-invite)))
   (setf (invite-num-guests obj) (cdr (assoc :num-guests raw-invite)))
   (update-dao obj)
   obj
  )
 )
)

