;;;; Contains helpers for handling html page generation (like generating headers and footers)

(in-package :irsvp)

(defun irsvp-prologue (html-stream page-title)
 (with-html-output (html-stream)
  (htm (:head (:title (str page-title))
   (:link :rel "stylesheet" :href "/irsvp.css")))))

(defmacro with-header-no-login ((html-stream) &body body)
 `(with-html-output (,html-stream)
     (:div :id "title-bar"
      (:span :id "title-logo" "iRSVP")
      ,@body)))

(defun header (html-stream)
 (with-header-no-login (html-stream)
  (if *session*
   ;; Need to work on the "if-user-already-is-logged-in bit". should the page present
   ;; logout/welcome message on separate lines? probably not.
   (htm (:span :id "title-username"
         (format html-stream "Welcome ~a! [<a href=\"/logout\">logout</a>]" (session-value 'id *session*))))
   (htm (:span :id "title-userinput" 
         (:form :action "login" :method "post"
          (:input :type "text" :name "email" :id "title-email")
          (:input :type "password" :name "password" :id "title-password")
          (:input :type "submit" :value "Login" :id "title-loginbutton")))
    (:span :id "title-register"
     (:a :href "/register" "Create an account"))))))

(defun footer (html-stream)
 (with-html-output (html-stream)
  (:div :id "footer"
   (:p "footer"))))

(defmacro with-header-and-footer ((title) &body body)
 (let ((var (gensym)))
  `(with-html-output-to-string (,var)
      (htm
       (:html 
        (irsvp-prologue ,var ,title)
        (:body (header ,var)
         ,@body
         (footer ,var)))))))

(defmacro defpage (name title &body body)
 `(defun ,name ()
     (with-header-and-footer (,title)
      ,@body)))


