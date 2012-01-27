(defpackage :humaweb
  (:documentation "humasect web framework")
  (:nicknames :hw)
  (:use :cl :cl-who :parenscript ;:css-lite
        )
  (:export
   ;; humaweb
   output-project
   *screen-width* *screen-height* *layer-scale*
   define-jsoutput define-htmloutput define-cssoutput

   ;; parenscript-additions
   ;;ps-to-stream*
   define-psmacros
   concat
   clog clogf
   setprop for-each ;;defproto
   sethtml
   _

   geom-js anim-js layer-js graph-js

#|
   ;; geom-js
   geom-js

   min max x y

   point-make point-makef
   point-x point-y
   point-scale
   circle-make circle-origin circle-x circle-y circle-radius

   size-make size-width size-height size-scale

   rect-make rect-origin rect-size
   rect-x rect-y rect-width rect-height rect-max-x rect-max-y
   rect-scale

   ;; anim-js
   anim-js

   ;; layer-js
   layer-js
   layer-make
   layer-add-sublayers
   layer-bounds
   layer-origin layer-size


   ;; graph-js
   graph-js

   ctx-set
   cg-save cg-restore

   cg-scale cg-rotate cg-translate cg-transform cg-set-transform

   cg-draw-image cg-draw-image-in cg-alpha cg-composite-operation

   cg-line-width cg-line-cap cg-line-miter cg-miter-limit
   cg-stroke-style cg-fill-style cg-shadow-blur cg-shadow-color

   cg-linear-gradient cg-radial-gradient cg-pattern cg-color-stop

   cg-font cg-text-align cg-text-baseline
   cg-fill-text cg-stroke-text cg-measure-text-width

   cg-clear-rect cg-fill-rect cg-stroke-rect

   cg-create-image-size cg-create-image-data
   cg-get-image cg-put-image
|#
   ))
