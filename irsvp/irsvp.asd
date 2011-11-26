(defpackage #:irsvp-system
 (:use :cl :asdf))

(in-package :asdf)

(defsystem "irsvp"
 :serial t
 :depends-on (:hunchentoot :cl-who :postmodern :cl-json)
 :components (
   (:module :server
    :serial t
    :components (
       (:static-file "irsvp.asd")
       (:file "package")
       (:file "parameters")
       (:file "html-helpers")
       (:file "session")
       (:file "bad-passwords")
       (:file "join")
       (:file "home")
       (:file "index")
       (:file "init")
       (:file "create-schema")
       (:file "event-model")
       (:file "event-controller")
       (:file "event-view")
       (:file "invite-model")
       (:file "invite-controller")
       (:file "invite-view")
       (:file "rsvp-view")
      )
    )
  )
)


