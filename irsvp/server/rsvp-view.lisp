(in-package :irsvp)

(defun report-missing-event-id-error ()
 ; TODO: report missing event ID error
)

(defun rsvp-view-render ()
 (with-html-output-to-string (html-stream)
  (:html :xmlns "http://www.w3.org/1999/xhtml"
   (:head
    (:link :href "/static/jquery-ui-1.8.14.custom.css" :media "all" :rel "stylesheet" :type "text/css")
    (:link :href "/static/bootstrap.min.css"
     :media "all" :rel "stylesheet" :type "text/css")
    (:link :href "/static/irsvp.css" :media "all" :rel "stylesheet" :type "text/css"))
   (:body
    (:script :type "text/javascript" :src "/static/json2.js")
    (:script :type "text/javascript" :src "/static/jquery-1.5.2.js")
    (:script :type "text/javascript" :src "/static/rsvp.js")
    (:script :type "text/javascript" "$(function() { init(); });")

    (:h1 "RSVP!")
    (:div :id "rsvp"
     (:div :id "rsvp-confirm"
      (:input :id "rsvp-code" :type "text" :placeholder "RSVP Code")
      (:input :id "rsvp-submit" :type "submit" :value "Submit")
     )
     (:div :id "rsvp-details" 
      (:div :class "details"
       (:h3 "you have been validated!")
      )
     )
    )
   )
  )
 )
)

(defconstant +invalid-rsvp+ (json:encode-json-to-string '((:valid . "false"))))
(defun rsvp-view-handle-get (rsvp-code)
 (with-connection *db-connection-parameters*
  (let* ((lowercase-code (string-downcase rsvp-code))
         (invite-query (select-dao 'invite (:= 'code lowercase-code)))
         (invite (car invite-query)))

   ; Check to make sure that there is an invite in the system with the 
   ; provided rsvp code.
   (if (null invite-query)
    +invalid-rsvp+
    (json:encode-json-to-string invite
    )
   )
  )
 )
)

(defun rsvp-view-handle-put (rsvp-code)
)

(defun rsvp-view-process-rsvp (rsvp-code method)
 (cond ((eq method :get) (rsvp-view-handle-get rsvp-code))
       ((eq method :put) (rsvp-view-handle-put rsvp-code))
 )
)

(defun rsvp-view (uri)
 (let* ((rsvp-code (cadr uri)))
  (if (or (null rsvp-code) (string= rsvp-code ""))
   (rsvp-view-render)
   (rsvp-view-process-rsvp rsvp-code (request-method* *request*)))
 )
)
