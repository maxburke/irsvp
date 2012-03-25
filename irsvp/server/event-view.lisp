(in-package :irsvp)

(defun event-view (uri)
 (if (null *session*)
  (redirect "/"))
 
 (if (null (cadr uri))
  (redirect "/"))

 (let* ((event-id (parse-integer (cadr uri) :junk-allowed t))
        (user-id (session-value 'id *session*)))
  (if (null event-id)
   (redirect "/"))
  (let ((name (event-get-name event-id)))
   (if (not (event-validate-for-user event-id user-id))
    (redirect "/"))

   (with-html-output-to-string (html-stream nil :prologue t)
    (:html :xmlns "http://www.w3.org/1999/xhtml"
     (:head
      (:link :href "/static/jquery-ui-1.8.14.custom.css" :media "all" :rel "stylesheet" :type "text/css")
      (:link :href "/static/bootstrap.min.css"
       :media "all" :rel "stylesheet" :type "text/css")
      (:link :href "/static/irsvp.css" :media "all" :rel "stylesheet" :type "text/css"))
     (:body
      (:script :type "text/javascript" :src "/static/json2.js")
      (:script :type "text/javascript" :src "/static/jquery-1.5.2.js")
      (:script :type "text/javascript" :src "/static/jquery-ui-1.8.14.custom.min.js")
      (:script :type "text/javascript" :src "/static/underscore-full.js")
      (:script :type "text/javascript" :src "/static/backbone-full.js")
      (:script :type "text/javascript" (fmt "eventId = ~a;" event-id))
      (:script :type "text/javascript" :src "/static/event.js")
      (:script :type "text/javascript" "$(function() { inviteList.init(); });")
 
      (:div :class "topbar"
       (:div :class "fill"
        (:div :class "container"
         (:a :href "/" :class "brand" "iRSVP")
         (:ul :class "nav"
          (:li (:a :href "/home" "Home"))
          (:li :class "active" (:a :href (str (request-uri* *request*)) (str name)))))))
 
      (:div :class "container"
       (:div :class "content"
        (:div :class "page-header"
         (:h1 (str name))
        )
         (:div :class "row"
          (:div :class "span10" (:h2 "Add a new guest!"))
          (:div :class "span4" 
            (:button :type "button" :id "new-invite-toggle" :class "btn pull-right" "Hide")
          )
         )
         (:div :id "invitelist-app"
          (:div :class "alert-message hidden" :id "new-invite-status")
          (:form :id "new-invite"
           (:fieldset
            (:div :class "clearfix"
             (:label :for "new-invite-email" "Guest contact email")
             (:div :class "input"
              (:input :class "xlarge" :id "new-invite-email" :type "text" :placeholder "joesmith@hotmail.com")
             )
            )
            (:div :class "clearfix"
             (:label :for "new-invite-first-name" "First name")
             (:div :class "input"
              (:input :class "xlarge" :id "new-invite-first-name" :type "text" :placeholder "Joe")
             )
            )
            (:div :class "clearfix"
             (:label :for "new-invite-last-name" "Last name")
             (:div :class "input"
              (:input :class "xlarge" :id "new-invite-last-name" :type "text" :placeholder "Smith")
             )
            )
            (:div :class "clearfix"
             (:label :for "new-invite-num-guests" "Number of guests")
             (:div :class "input"
              (:input :class "mini" :id "new-invite-num-guests" :type "text" :placeholder "17")
             )
            )
            (:div :class "actions"
             (:button :type "button" :class "btn primary" :id "add-guest" "Add guest")
             " "
             (:button :type "button" :class "btn" :id "cancel" "Cancel")
            )
           )
          )
         )
        (:ul :id "invite-list")
        )
       (:footer
        (:p "&copy; fvwsw.com")))
      )
    )
   )
  )
 )
)

