(defpackage :humaweb-asd)
(in-package :humaweb-asd)

(asdf:defsystem humaweb
  :name "HumaWeb"
  :version "2"
  :maintainer "Lyndon Tremblay"
  :author "Lyndon Tremblay"
  :description "humasect web stuff"
  :serial t
  :depends-on (:cl-who :parenscript)
  :components ((:file "package")
               (:file "parenscript-additions")
               (:file "humaweb")
               (:file "geom-js")
               (:file "graph-js")
               (:file "layer-js")
               (:file "anim-js")))
