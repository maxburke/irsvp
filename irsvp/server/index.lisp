(in-package :irsvp)

(defun index-handler ()
 (if *session*
  (redirect "/home"))

 (with-html-output-to-string (html-output-string)
  (:html
   (irsvp-prologue html-output-string "iRSVP")
   (:body 
    (:div :id "login-block"
     (:form :action "/login" :method "post"
      (:label :for "login-email" "email")
      (:input :type "text" :name "email" :id "login-email")
      (:label :for "login-password" "password")
      (:input :type "password" :name "password" :id "login-password")
      (:input :type "submit" :value "login" :id "login-submit")))
    (:div :id "new-membership"
     "not a user? " 
     (:a :href "/join" "join now!"))
   )
  )
 )
)


