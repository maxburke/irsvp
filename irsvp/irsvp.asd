(defpackage #:irsvp-system
 (:use :cl :asdf))

(in-package :asdf)

(defsystem "irsvp"
 :serial t
 :depends-on (:hunchentoot :cl-who :postmodern :cl-json :irsvp-client)
 :components (
   (:module :server
    :serial t
    :components (
       (:static-file "irsvp.asd")
       (:file "package")
       (:file "parameters")
;       (:file "html-helpers")
       (:file "session")
       (:file "bad-passwords")
;       (:file "join")
;       (:file "home")
;       (:file "index")
;       (:file "log")
       (:file "init")
;       (:file "create-schema")
      )
    )
  )
)


