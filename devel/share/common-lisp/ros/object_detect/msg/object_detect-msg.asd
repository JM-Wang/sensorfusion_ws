
(cl:in-package :asdf)

(defsystem "object_detect-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "object_detect_result" :depends-on ("_package_object_detect_result"))
    (:file "_package_object_detect_result" :depends-on ("_package"))
  ))