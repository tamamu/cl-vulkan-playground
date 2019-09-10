(in-package :cl-vulkan-playground)

(defun %foreign-array-to-lisp (array type count)
  (loop for i from 0 below count collect (cffi:mem-aref array type i)))

(defun %foreign-struct-to-plist (struct type)
  (loop for slot-name in (cffi:foreign-slot-names type)
        collect slot-name
        collect (cffi:foreign-slot-value struct type slot-name)))

(defun show-vkinfo (instance)
  (let ((devices (vk:enumerate-physical-devices instance)))
    (format t "~&instance layers: ~s~%"
            (mapcar #'(lambda (p) (getf p :layer-name))
                    (vk:enumerate-instance-layer-properties)))
    (format t "~&instance extensions: ~s~%"
            (mapcar #'(lambda (p) (getf p :extension-name))
                    (vk:enumerate-instance-extension-properties "")))
    (format t "~&got ~d devices~%"
            (length devices))
    (loop for device in devices
          for i from 0
          for props = (vk:get-physical-device-properties device)
          do (format t "device ~d: ~a~%"
                     i (getf props :device-name))
          (format t "device layers: ~s~%"
                  (cffi:with-foreign-objects
                    ((layer-count :uint32)
                     (properties '(:struct %vk:layer-properties)))
                    (setf (cffi:mem-ref layer-count :uint32) 0)
                    (%vk:enumerate-device-layer-properties device layer-count (cffi:null-pointer))
                    (setf properties
                          (cffi:foreign-alloc '(:struct %vk:layer-properties)
                                              :count (cffi:mem-ref layer-count :uint32)))
                    (%vk:enumerate-device-layer-properties device layer-count properties)
                    (mapcar #'(lambda (p) (cffi:foreign-string-to-lisp (getf p :layer-name)))
                            (%foreign-array-to-lisp properties '(:struct %vk:layer-properties) (cffi:mem-ref layer-count :uint32)))))
          (format t "device extensions: ~s~%"
                  (cffi:with-foreign-objects
                    ((extension-count :uint32)
                     (properties '(:struct %vk:extension-properties)))
                    (setf (cffi:mem-ref extension-count :uint32) 0)
                    (%vk:enumerate-device-extension-properties device "" extension-count (cffi:null-pointer))
                    (setf properties
                          (cffi:foreign-alloc '(:struct %vk:extension-properties)
                                              :count (cffi:mem-ref extension-count :uint32)))
                    (%vk:enumerate-device-extension-properties device "" extension-count properties)
                    (mapcar #'(lambda (p) (cffi:foreign-string-to-lisp (getf p :extension-name)))
                            (%foreign-array-to-lisp properties '(:struct %vk:extension-properties) (cffi:mem-ref extension-count :uint32)))))
          (format t "queue families: ~s~%"
                  (cffi:with-foreign-objects
                    ((queue-family-count :uint32)
                     (queue-family-properties '(:struct %vk:queue-family-properties)))
                    (setf (cffi:mem-ref queue-family-count :uint32) 0)
                    (%vk:get-physical-device-queue-family-properties device queue-family-count (cffi:null-pointer))
                    (setf queue-family-properties
                          (cffi:foreign-alloc '(:struct %vk:queue-family-properties)
                                              :count (cffi:mem-ref queue-family-count :uint32)))
                    (%vk:get-physical-device-queue-family-properties device queue-family-count queue-family-properties)
                    (%foreign-array-to-lisp queue-family-properties '(:struct %vk:queue-family-properties) (cffi:mem-ref queue-family-count :uint32))))
          (format t " limits:~%  ~{~s ~s~^~% ~}~%" (getf props :limits))
          (remf props :limits)
          (format t " properties:~%  ~{~s ~s~^~% ~}~%" props)
          (format t " features:~%  ~{~s ~S~^~% ~}~%"
                  (cffi:with-foreign-objects
                    ((p-features '(:struct %vk:physical-device-features)))
                    (%vk:get-physical-device-features device p-features)
                    (%foreign-struct-to-plist p-features '(:struct %vk:physical-device-features))))
          (let ((format :r8-snorm))
            (format t " properties of format ~s :~%~{  ~s ~s~%~}" format
                    (cffi:with-foreign-objects
                      ((p-format-properties '(:struct %vk:format-properties)))
                      (%vk:get-physical-device-format-properties device format p-format-properties)
                      (%foreign-struct-to-plist p-format-properties '(:struct %vk:format-properties)))))
          (format t " physical device memory properties:~%~{ ~s ~s~%~}"
                  (cffi:with-foreign-objects
                    ((p-memory-properties '(:struct %vk:physical-device-memory-properties)))
                    (%vk:get-physical-device-memory-properties device p-memory-properties)
                    (%foreign-struct-to-plist p-memory-properties '(:struct %vk:physical-device-memory-properties)))))
    t))

