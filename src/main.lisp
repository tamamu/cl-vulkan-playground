(in-package :cl-vulkan-playground)

(defun main ()
  (vk:with-instance
    (instance)
    (when instance
      (show-vkinfo instance))))
