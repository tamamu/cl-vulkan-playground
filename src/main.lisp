(in-package :cl-vulkan-playground)

(defun run ()
  (vk:with-instance
    (instance)
    (when instance
      (show-vkinfo instance))))
