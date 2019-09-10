(defsystem :cl-vulkan-playground
  :description "Play with 3b/cl-vulkan"
  :author "Eddie"
  :license "MIT"
  :version "1.0"
  
  :depends-on (:cl-vulkan)
  :in-order-to ((test-op (test-op "cl-vulkan-playground/tests")))
  
  :components
  ((:module "src"
    :components
    ((:file "package")
     (:file "vkinfo")
     (:file "main")))))

(defsystem :cl-vulkan-playground/tests
  :description "Test system for cl-vulkan-playground"
  :author "Eddie"
  :license "MIT"

  :depends-on (:cl-vulkan-playground
               :rove)
  :perform (test-op (op c) (symbol-call :rove :run c))

  :components
  ((:module "tests"
    :components
    ((:file "main")))))
