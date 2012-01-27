(in-package :humaweb)

(define-psmacros ctx
  (call (n &body body) `((chain *ctx* ,n) ,@body))
  (set (k v) `(setf (@ *ctx* ,k) ,v))
  (rectcall (n r) `(ctx-call ,n (rect-x ,r) (rect-y ,r)
                             (rect-width ,r) (rect-height ,r))))

(define-psmacros cg
 (save () `(ctx-call save))
 (restore () `(ctx-call restore)))


(define-psmacros cg ; transformation
  (scale (x y) `(ctx-call scale ,x ,y))
  (rotate (a) `(ctx-call rotate ,a))
  (translate (p) `(ctx-call translate (x ,p) (y ,p)))
  (transform (m11 m12 m21 m22 dx dy)
             `(ctx-call transform ,m11 ,m12 ,m21 ,m22 ,dx ,dy))
  (set-transform (m11 m12 m21 m22 dx dy)
                 `(ctx-call set-transform ,m11 ,m12 ,m21 ,m22 ,dx ,dy)))

(define-psmacros cg ; image
  (draw-image (image point size)
              `(ctx-call draw-image ,image
                         (x ,point) (y ,point)
                         (size-width ,size) (size-height ,size)))

  (draw-image-in (image sr dr)
                 `(ctx-call draw-image ,image
                            (rect-x ,sr) (rect-y ,sr)
                            (rect-width ,sr) (rect-height ,sr)
                            (rect-x ,dr) (rect-y ,dr)
                            (rect-width ,dr) (rect-height ,dr)))

  (alpha (a) `(ctx-set global-alpha ,a))
  (composite-operation (op) `(ctx-set global-composite-operation ,op)))

(define-psmacros cg ; styles
  (line-width (w) `(ctx-set line-width ,w))
  (line-cap (cap) `(ctx-set line-cap ,(string cap)))
  (line-join (join) `(ctx-set line-join ,(string join)))
  (miter-limit (limit) `(ctx-set miter-limit ,limit))

  (stroke-style (style) `(ctx-set stroke-style ,style))
  (fill-style (style) `(ctx-set fill-style ,style))

  ;; implemented below in JS
  ;; (defpsmacro cg-shadow-offset (p)
  ;;   `(let ((pp ,p))
  ;;      (ctxset shadow-offset-x (.x pp))
  ;;      (ctxset shadow-offset-y (.y pp))))
  
  (shadow-blur (b) `(ctx-set shadow-blur ,b))
  (shadow-color (c) `(ctx-set shadow-color ,c))

  (linear-gradient (a b) `(ctx-call create-linear-gradient
                                    (x ,a) (y ,a) (x ,b) (y ,b)))

  (radial-gradient (a b) `(ctx-call create-radial-gradient
                                    (circle-x ,a) (circle-y ,a)
                                    (circle-radius ,a)
                                    (circle-x ,b) (circle-y ,b)
                                    (circle-radius ,b)))

  (pattern (image rep) `(ctx-call create-pattern ,image ,rep))
  (color-stop (offset color) `(ctx-call add-color-stop ,offset ,color)))

;; paths!

;; this will be like turtle graphics. (cg-path (list ...))
;; (defpsmacro cg-begin-path () `(ctxcall begin-path))
;; (defpsmacro cg-close-path () `(ctxcall close-path))
;; (defpsmacro cg-fill () `(ctxcall fill))

(define-psmacros cg ; text
  (font (size name) `(setf (@ *ctx* font) (concat ,size "px " ,name)))

  (text-align (align) `(ctx-set text-align ,(string align)))
  (text-baseline (bl) `(ctx-set text-baseline ,(string bl)))

  ;; these two do not use maxWidth third arg
  (fill-text (str pt) `(ctx-call fill-text ,str (x ,pt) (y ,pt)))
  (stroke-text (str pt) `(ctx-call stroke-text ,str (x ,pt) (y ,pt)))

  (measure-text-width (text) `(chain (ctx-call measure-text ,text) widtn)))

(define-psmacros cg ; rect
  (clear-rect (r) `(ctx-rectcall clear-rect ,r))
  (fill-rect (r) `(ctx-rectcall fill-rect ,r))
  (stroke-rect (r) `(ctx-rectcall stroke-rect ,r)))

(define-psmacros cg ; pixel and image
  (create-image-size (size) `(ctx-call create-image-data
                                       (size-width ,size) (size-height ,size)))
  (create-image-data (image) `(ctx-call create-image-data ,image))

  (get-image-data (r) `(ctx-rectcall get-image-data ,r)))
  ;(defpsmacro cg-put-image-data (image dest-point dirty-rect))

(define-jsoutput graph
  (var *screen-width* (lisp *screen-width*))
  (var *screen-height* (lisp *screen-height*))
  (var *ctx* null)
  (var *screen* null)

  (defun cg-shadow-offset (p)
    (ctx-set shadow-offset-x (x p))
    (ctx-set shadow-offset-y (y p))
    (return))

  (defun start-graph ()
    (setf *ctx* (chain (@ ($ "#screen-canvas") 0) (get-context "2d")))
    (cg-font 32 "helvetica")

    (setf *screen* (layer-make
                    :name "*screen*"
                    :bounds (rect-make
                             0 0
                             *screen-width*
                             *screen-height*)))
    (start-main))

  (chain ($ document) (ready start-graph))
  )


