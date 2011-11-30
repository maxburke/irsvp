(in-package :irsvp)

(defvar *server-instance* nil)
(defvar *irsvp-index* #p"/home/max/src/lisp/irsvp/index.html")
(defvar *db-connection-parameters* (list "irsvp" "irsvp" "irsvp" "localhost" :pooled-p t))

;; Encode the user agent into the session secret so that a new session is required if this changes.
(setf *use-user-agent-for-sessions* t)
;; Encode the remote address into the session secret so that a new session is required if this changes.
(setf *use-remote-addr-for-sessions* t)
;; Set the session max time to be 7 days.
(setf *session-max-time* 604800)
; Permit post-parameters to be retrieved from PUT and DELETE methods, as well as POST
(nconc *methods-for-post-parameters* '(:put :delete))

; These three should be *off* for release.
(setf *show-lisp-errors-p* t)
(setf *message-log-pathname* #p"/Users/max/src/lisp/irsvp/logs/message.log")
(setf *access-log-pathname* #p"/Users/max/src/lisp/irsvp/logs/access.log")
(defvar *irsvp-debug* t)

(if *irsvp-debug*
 (defmacro server-log (str)
  `(log-message *lisp-warnings-log-level* ,str))
 (defmacro server-log (str)))

; Debugging facilities
(defvar *irsvp-debug* t)

(if *irsvp-debug*
 (defmacro server-log (str)
  `(log-message *lisp-warnings-log-level* ,str))
 (defmacro server-log (str)))

; Tell Hunchentoot to not handle 404 specially. This lets the server application return
; a "not found" status code if certain records aren't found, without sending back error
; text.
(nconc *approved-return-codes* (list +http-not-found+))
