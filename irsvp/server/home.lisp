(in-package :irsvp)
    
    
(defun home-handler ()
 (if (null *session*)
  (redirect "/"))

 (with-html-output-to-string (html-stream)
  (:html :xmlns "http://www.w3.org/1999/xhtml"
   (:head
    (:link :href "http://av8r.ca/css/jquery-ui-1.8.14.custom.css" :media "all" :rel "stylesheet" :type "text/css")
    (:link :href "http://twitter.github.com/bootstrap/1.3.0/bootstrap.min.css"
     :media "all" :rel "stylesheet" :type "text/css")
    (:link :href "irsvp.css" :media "all" :rel "stylesheet" :type "text/css"))
   (:body
    (:script :type "text/javascript" :src "http://av8r.ca/js/json2.js")
    (:script :type "text/javascript" :src "http://av8r.ca/js/jquery-1.5.2.js")
    (:script :type "text/javascript" :src "http://av8r.ca/js/jquery-ui-1.8.14.custom.min.js")
    (:script :type "text/javascript" :src "http://av8r.ca/js/underscore-full.js")
    (:script :type "text/javascript" :src "http://av8r.ca/js/backbone-full.js")
;    (:script :type "text/javascript" :src "irsvp.js")
;    (:script :type "text/javascript" "$(function() { iRSVP.init(); });")

    (:div :class "topbar"
     (:div :class "fill"
      (:div :class "container"
       (:a :href "/home" :class "brand" "iRSVP")
       (:ul :class "nav"
        (:li :class "active" (:a :href "/home" "Home"))
        (:li (:a :href "/logbook" "Logbook"))
        (:li (:a :href "/settings" "Settings")))
       (:form :action "post"
        (:input :type "text" :placeholder "search!")))))

    (:div :class "container"
     (:div :class "content"
      (:div :class "page-header"
       (:h1 "My Log"))
      (:div :class "row"
       (:div :class "content-container"
        (:div :id "irsvp-app"
         (:div :class "new-entry"
          (:div :class "new-entry-title" 
           (:h2 "Add a new dive!"))
          (:input :type "text" :class "date-widget log-date-input" :placeholder "Date")
          (:input :type "text" :class "log-duration-input" :placeholder "Duration")
          (:input :type "text" :class "log-depth-input" :placeholder "Depth")
          (:input :type "text" :class "log-location-input" :placeholder "Location")
          (:textarea :class "log-notes-input" :placeholder "Notes")))
        (:ul :id "log-list"))))
     (:footer
      (:p "&copy; Teutonic Penguin Software 2011")))
   )
  )
 )
)
