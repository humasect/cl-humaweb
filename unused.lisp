;; try to help layer making

(defpsmacro deflayer (&key (name "")
                           (sublayers nil)
                           (fill-style "blue")
                           (stroke-style "white")
                           (bounds nil))
  `(create superlayer null
           name (if (,name) ,name null)
           sublayers (if (,sublayers) ,sublayers null)
           bounds (if (,bounds) ,bounds (rect-make 0 0 0 0))
           fill-style ,fill-style
           stroke-style ,stroke-style))

;; jquery main

(defmacro main-js-query ()
  `(progn
     (var *tile-width* 24)
     (var *tile-height* 30)
     (var *map-width* 32)
     (var *map-height* 24)

     (defun for-each-tile (fun)
       (loop for i from 0 to *map-width*
          do (loop for j from 0 to *map-height*
                do (fun i j))))

     (defun clear-map () (chain ($ "#view") (html "")))
     (defun tile-id (x y) (concatenate 'string "tile_" x "_" y))

     (defun set-tile (x y type)
       (let ((c ($ (tile-id x y)))
             (class (cond ((= type "#") "wall"))))
         (chain c (html type) (add-class class))))

     (defun create-map ()
       (for-each-tile
        (lambda (x y)
          (let ((c ($"<div/>"))
                (left (+ (* x *tile-width*) 64))
                (top (+ (* y *tile-height*) 64)))
            (chain c
                   (attr "id" (tile-id x y))
                   (add-class "tile")
                   (css (create :left left
                                :top top
                                :background-color "green"))
                   (html "#"))
            (chain ($ "#view") (append c))))))

     (chain ($ document) (ready create-map))))
