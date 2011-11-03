(in-package :irsvp)

(defconstant +no+ 0)
(defconstant +yes+ 1)
(defconstant +declined+ 2)

(defvar *code-chars* "0123456789abcdefghijklmnopqrstuv")

;; TODO: I need to make this a little better. Perhaps it's worth keeping some
;; sort of counter in the application that we concatenate with the current
;; time? That'd work, so that at least the invites should be unique even if
;; the application is restarted.
(defun invite-create-code ()
 (let ((time (get-universal-time))
       (code '()))
  (labels ((recursive-create-code (code-base)
            (let ((fragment (logand code-base 31))
                  (remainder (ash code-base -5)))
             (if (not (zerop remainder))
              (progn
               (push (elt *code-chars* fragment) code)
               (recursive-create-code remainder)))
            )))
   (recursive-create-code time))
  (coerce code 'string)
 )
)

(defun invite-status-to-symbol (status)
 (case status
  (0 'not-responded)
  (1 'accepted)
  (2 'declined)
 )
)

(defun invites-fetch (event-id)
 (with-connection *db-connection-parameters*
  (let ((records (select-dao 'invite (:= 'event-id event-id)))
        (invites-list '()))
   (mapcar (lambda (invite)
            (push (vector
                   (invite-id invite)
                   (invite-last-name invite)
                   (invite-first-name invite)
                   (invite-code invite)
                   (invite-email invite)
                   (invite-status-to-symbol (invite-responded invite))) invites-list)) records)
   (nreverse invites-list)
  )
 )
)
