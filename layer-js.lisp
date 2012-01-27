(in-package :humaweb)

(define-psmacros layer
  (make (&key (name "")
              (fill-style "black")
              (stroke-style "white")
              (bounds nil bounds-supplied-p)
              (contents nil)
              (render nil))
        `(create name ,name
                 superlayer null
                 sublayers '()
                 parent nil
                 bounds ,(if bounds-supplied-p bounds `(rect-make 0 0 1 1))
                 fill-style ,fill-style
                 stroke-style ,stroke-style
                 contents ,contents
                 render ,render
                 animations '()))

  (bounds (l) `(rect-scale (@ ,l bounds) (lisp *layer-scale*)))

  (add-sublayers (l lst) `(for-each s ,lst (layer-add-sublayer ,l s)))
  
  (origin (l) `(@ ,l bounds origin))
  (size (l) `(@ ,l bounds size)))

(define-jsoutput layer
  (defun layer-add-sublayer (l s)
    ;; does not check if layer is already present.
    ;;(append (@ l sublayers) (list s))
    ((chain (@ l sublayers) push) s)
    (setf (@ s parent) l))

  (defun sublayer-named (l name)
    (var found null)
    (for-each s (@ l sublayers) (if (= (@ s name) name)
                                    (setf found s)))
    found)

  (defun layer-render (l)
    (if (not (= (@ l contents) 'empty))
        (progn
          (cg-fill-style (@ l fill-style))
          (cg-stroke-style (@ l stroke-style))

          (if (@ l render)
              ((@ l render))
              (let ((bounds (layer-bounds l)))
                (if (stringp (@ l contents))
                    (cg-fill-text (@ l contents) (rect-origin bounds))
                    (cg-fill-rect bounds))))))

    (for-each s (@ l sublayers) (layer-render s)))

  )
