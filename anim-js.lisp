(in-package :humaweb)

(define-jsoutput anim
  (var *anim-interval* null)

  (defun anim-start ()
    (setf *anim-interval*
          (set-interval anim-loop (/ 1000 30))))
  
  (defun anim-stop ()
    (clear-interval *anim-interval*)
    (setf *anim-interval* null))

  (defun anim-loop ()
    (defun move-layer (l)))
  )




