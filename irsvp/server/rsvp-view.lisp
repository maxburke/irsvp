(in-package :irsvp)

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
        (:form
         (:fieldset
          (:div :class "clearfix"
           (:label :for "rsvp-code" "RSVP Code")
           (:div :class "input"
            (:input :class "small" :id "rsvp-code" :size "10" :type "text")
           )
          )
          (:div :class "actions"
           (:button :id "rsvp-submit" :type "button" :class "btn primary" "Submit")
          )
         )
        )
       )
       (:div :id "rsvp-details" 
        (:div :class "details"
         (:form
          (:fieldset
           (:div :class "clearfix"
            (:label :for "rsvp-email" "Please confirm your email address")
            (:div :id "input"
             (:input :id "rsvp-email" :type "text" :class "xlarge")
            )
           )
           (:div :class "clearfix"
            (:label :for "rsvp-number" "Attendance")
            (:div :id "input"
             (:span :id "rsvp-number")
            )
           )
           (:div :class "clearfix"
            (:label :for "rsvp-special" "Names of those attending, best wishes, special requests")
            (:div :class "input"
             (:textarea :id "rsvp-special" :class "xxlarge" :rows "3")
            )
           )
           (:div :class "actions"
            (:button :id "rsvp-confirm-submit" :type "button" :class "btn primary" "Confirm!")
           )
          )
         )
        )
;        (:div :class "details"
;         (:ul
;          (:li
;           (:label :for "rsvp-email" "Please confirm your email address")
;           (:input :id "rsvp-email" :type "text")
;          )
;          (:li
;           (:label :for "rsvp-number" "Attendance")
;           (:span :id "rsvp-number")
;          )
;          (:li
;           (:label :for "rsvp-special" "Names of those attending, best wishes, special requests")
;           (:input :id "rsvp-special" :type "text")
;          )
;          (:li
;           (:button :id "rsvp-confirm-submit" :type "button" :class "btn primary" "Confirm!")
;          )
;         )
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
