(in-package :humaweb)

(define-psmacros nil
  (min (x y) `(if (> ,x ,y) ,x ,y))
  (max (x y) `(if (> ,x ,y) ,x ,y))

  ;; point
  (x (p) `(@ ,p x))
  (y (p) `(@ ,p y)))

(define-psmacros point
  (make (x y) `(create x ,x y ,y))
  (makef (x y f) `(create x (,f ,x) (,f ,y)))
  (x (p) `(@ ,p x))
  (y (p) `(@ ,p y))

  (mod (p fun) `(point-make (,fun (x ,p)) (,fun (y ,p))))
  (scale (p s) `(point-make (* (x ,p) ,s) (* (y ,p) ,s))))

(define-psmacros circle
  (make (x y r) `(create origin (point-make ,x ,y) radius ,r))
  (origin (c) `(@ ,c origin))
  (x (c) `(x (circle-origin ,c)))
  (y (c) `(y (circle-origin ,c)))
  (radius (c) `(@ ,c radius)))

(define-psmacros size
  (make (w h) `(create width ,w height ,h))
  (width (s) `(@ ,s width))
  (height (s) `(@ ,s height))
  (scale (s ss) `(size-make (* (size-width ,s) ,ss)
                            (* (size-height ,s) ,ss))))

(define-psmacros rect
  (make (x y w h) `(create origin (point-make ,x ,y)
                           size (size-make ,w ,h)))

  (origin (r) `(@ ,r origin))
  (size (r) `(@ ,r size))
  (x (r) `(x (rect-origin ,r)))
  (y (r) `(y (rect-origin ,r)))
  (width (r) `(size-width (rect-size ,r)))
  (height (r) `(size-height (rect-size ,r)))
  (max-x (r) `(+ (rect-x ,r) (rect-width ,r)))
  (max-y (r) `(+ (rect-y ,r) (rect-height ,r)))

  (scale (r s) `(create origin (point-scale (rect-origin ,r) ,s)
                        size (size-scale (rect-size ,r) ,s))))

(define-jsoutput geom
  ;; misc
  (defun deg-to-rad (c) (/ (* c pi) 180.0))
  (defun rad-to-deg (c) (/ (* c 180.0) pi))

  ;;
  ;; point
  ;;

  (defun point-dot (a b)
    (+ (* (x a) (x b))
       (* (y a) (y b))))

  (defun point-magnitude (p)
    (sqrt (point-dot p p)))

  (defun point-divide (p s)
    (point-make (/ (x p) s)
                (/ (y p) s)))

  (defun point-add (a b)
    (point-make (+ (x a) (x b))
                (+ (y a) (y b))))

  (defun point-subtract (a b)
    (point-make (- (x a) (x b))
                (- (y a) (y b))))


  (defun point-normal (p)
    (var m (point-magnitude p))
    (if (not (= m 0))
        (point-divide p m)
        p))

  (defun point-rotate (p te)
    (let ((ct (cos te))
          (st (sin te)))
      (create x (- (* ct (x p)) (* st (y p)))
              y (+ (* st (x p)) (* ct (y p))))))

  (defun angle-between-points (first second)
    (let ((diff (point-subtract second first)))
      (atan2 (x diff) (y diff))))

  (defun point-snap (p sz)
    (point-make (* (round (/ (x p) sz)) sz)
                (* (round (/ (y p) sz)) sz)))

  ;;
  ;; circle
  ;;

  ;;
  ;; random
  ;;
  (defun random-signed ()
    (- (* (random) 2) 1))

  (defun random-in-range (min max)
    ;; check that min is smoller than max
    (+ min (* (random) (- max min))))

  (defun random-point-in-rect (r)
    (point-make  (random-in-range (rect-x r) (rect-max-x r))
                 (random-in-range (rect-y r) (rect-max-y r))))

  (defun random-point-in-circle (c)
    (let ((p (point-normal (point-make (random-signed) (random-signed)))))
      (point-add (point-scale p (circle-radius c)) (circle-origin c))))

  (defun random-array-element (arr)
    (chain arr (random-in-range 0 (length arr))))

  ;;
  ;; etc
  ;;
  (defun keep-point-in-rect (p r)
    (point-make (cond ((< (x p) (rect-x r)) (rect-x r))
                      ((>= (x p) (rect-max-x r)) (rect-max-x r))
                      (t (x p)))
                (cond ((< (y p) (rect-y r)) (rect-y r))
                      ((>= (y p) (rect-max-y r)) (rect-max-y r))
                      (t (y p)))))

  )


