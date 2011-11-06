(in-package :irsvp)

(defun event-view (uri)
 (if (null *session*)
  (redirect "/"))
 
 (if (null (cadr uri))
  (redirect "/"))

 (let* ((event-id (parse-integer (cadr uri) :junk-allowed t))
        (user-id (session-value 'id *session*))
        (name (event-get-name event-id)))
  (if (not (event-validate-for-user event-id user-id))
   (redirect "/"))

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
        (:div :class "row"
         (:div :class "content-container"
          (:div :id "invitelist-app"
           (:div :class "new-invite"
            (:div :class "new-invite-title"
             (:h2 "Add to the guest list!"))
            (:input :type "text" :class "invite-email-input" :placeholder "email")
            (:input :type "text" :class "invite-last-name-input" :placeholder "last name")
            (:input :type "text" :class "invite-first-name-input" :placeholder "first name")))
          (:ul :id "invite-list")))))
      (:footer
       :p "&copy; fvwsw.com"))
    )
   )
  )
 )
)
