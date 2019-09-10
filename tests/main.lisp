(defpackage cl-vulkan-playground/tests/main
  (:use :cl
        :cl-vulkan-playground
        :rove))
(in-package :cl-vulkan-playground/tests/main)

(deftest success-vkinfo
  (vk:with-instance (instance)
    (testing "vkinfo"
      (ok (show-vkinfo instance)))))
