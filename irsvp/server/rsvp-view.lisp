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
    (:script :type "text/javascript" :src "/static/bootstrap-modal.js")
    (:script :type "text/javascript" :src "/static/rsvp.js")
    (:script :type "text/javascript" "$(function() { init(); });")

    (:div :id "rsvp-status" :class "modal hide fade"
     (:div :class "modal-header"
      (:a :class "close" "&times;")
      (:div :id "modal-header-text")
     )
     (:div :class "modal-body"
      (:div :id "modal-body-text")
     )
     (:div :class "modal-footer"
      (:button :class "btn close" :type "button" "OK")
     )
    )
    (:div :class "topbar"
     (:div :class "fill"
      (:div :class "container"
       (:ul :class "nav"
        (:li
         (:a :href "/" (:img :src "/static/icons/irsvp-72x20.png")))))))
    (:div :class "container"
     (:div :class "content"
      (:div :class "page-header"
       (:h1 "RSVP!")
      )

      (:div :id "rsvp"
       (:div :id "rsvp-confirm"
        (:input :id "rsvp-code" :type "text" :placeholder "RSVP Code")
        (:input :id "rsvp-submit" :type "submit" :value "Submit")
       )
       (:div :id "rsvp-details" 
        (:div :class "details"
         (:input :id "rsvp-email" :type "text")
         (:span :id "rsvp-number")
         (:input :id "rsvp-special" :type "text")
        )
       )
      )

      (:footer
       (:p "&copy; fvwsw.com"))
     )
    )
   )
  )
 )
)

(defvar *invalid-rsvp* (json:encode-json-to-string '((:valid . "false"))))
(defun rsvp-view-handle-get (rsvp-code)
 (with-connection *db-connection-parameters*
  (let* ((lowercase-code (string-downcase rsvp-code))
         (invite-query (select-dao 'invite (:= 'code lowercase-code)))
         (invite (car invite-query)))

   ; Check to make sure that there is an invite in the system with the 
   ; provided rsvp code.
   (if (null invite-query)
    (progn (setf (return-code*) +http-not-found+)
     *invalid-rsvp*)
    (json:encode-json-to-string invite)
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
