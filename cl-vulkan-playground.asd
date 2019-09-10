(defsystem :cl-vulkan-playground
  :description "Play with 3b/cl-vulkan"
  :author "Eddie"
  :license "MIT"
  :version "1.0"
  
  :depends-on (:cl-vulkan)
  :pathname "src"
  :serial t
  
  :components
  ((:file "package")
   (:file "vkinfo")
   (:file "main")))
