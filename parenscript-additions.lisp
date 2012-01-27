(in-package :humaweb)

;; (defmacro ps-to-stream* (stream &body body)
;;   `(progn (setf *parenscript-stream* ,stream)
;;           (ps* (macroexpand-1 ,@body))))

(defmacro concat (&body body) `(concatenate 'string ,@body))

(defmacro define-psmacros (prefix &rest lst)
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     ,(cons 'progn
            (mapcar (lambda (l)
                      (let ((name (if prefix
                                      (intern
                                       (concat (string prefix) "-"
                                               (string-upcase (car l))))
                                      (car l)))
                            (args (cadr l))
                            (body (cddr l)))
                        `(progn
                           (defpsmacro ,name ,args ,@body)
                           (export ',name))))
                    lst))))

(define-psmacros nil
  ;; js
  (concat (&body body) `(concatenate 'string ,@body))
  (clog (fmt) `((@ console log) ,fmt))
  (clogf (fmt &rest args) `((@ console log) (concat ,fmt ,@args)))

  ;; unused
  ;; (defproto (class name &body body)
  ;;     `(setf (@ ,class prototype ,name) ,@body))

  (setprop (object key value) `(setf (@ ,object ,key) ,value))

  (for-each (var x &body body)
            `(for-in (__i ,x) (let ((,var (getprop ,x __i))) ,@body)))

  ;; jquery js
  ($# (name) `($ ,(concat "#" (string name))))

  (sethtml (el &optional (markup nil markup-supplied-p))
           `((chain ($ ,el) html) ,(if markup-supplied-p
                                       `(who-ps-html ,markup)
                                       "")))

  ;; underscore js
  ( _ (fun &body body) `((chain _ ,fun) ,@body))

  )



