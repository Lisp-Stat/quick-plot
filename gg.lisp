;;; -*- Mode: LISP; Syntax: Ansi-Common-Lisp; Base: 10; Package: GG -*-
;;; Copyright (c) 2026 Symbolics Pte. Ltd. All rights reserved.
;;; Geometry helpers for common Vega-Lite plot types.

(in-package #:gg)

(defun label (&key x y)			;'labels' is a CL keyword
  "Return a plist with axis title encodings, suitable for merging.
Sets the :title property directly on each encoding channel rather than
nesting inside :axis, so that composite marks like boxplot (which
expand into multiple sub-layers) resolve a single authoritative title
instead of concatenating the field name with per-layer axis titles."
  `(,@(when (or x y)
        `(:encoding (,@(when x `(:x (:title ,x)))
                     ,@(when y `(:y (:title ,y))))))))

(defun axes (&key x-type y-type
               x-domain y-domain
               x-range y-range
               color-scheme)
  "Return a plist with scale encodings, suitable for merging.
X-TYPE/Y-TYPE: :log :sqrt :time etc.
X-DOMAIN/Y-DOMAIN: explicit (min max) domain list
X-RANGE/Y-RANGE: explicit (min max) range list
COLOR-SCHEME: a Vega scheme name e.g. :category10 :viridis"
  `(,@(when (or x-type x-domain x-range)
        `(:encoding (:x (:scale (,@(when x-type `(:type ,x-type))
				 ,@(when x-domain `(:domain ,x-domain))
				 ,@(when x-range `(:range ,x-range)))))))
    ,@(when (or y-type y-domain y-range)
        `(:encoding (:y (:scale (,@(when y-type `(:type ,y-type))
				 ,@(when y-domain `(:domain ,y-domain))
				 ,@(when y-range `(:range ,y-range)))))))
    ,@(when color-scheme
        `(:encoding (:color (:scale (:scheme ,color-scheme)))))))

(defun tooltip (&rest fields)
  "Return encoding plist adding tooltip channels.
Each field is one of:
  :keyword            — nominal field (shorthand)
  (:keyword :type)    — field with explicit type, e.g. (:horsepower :quantitative)
  (:field f :type t)  — full Vega-Lite channel plist (passed through)
The result uses a vector so the serializer emits a JSON array."
  (let ((channels (mapcar (lambda (f)
			    (cond ((keywordp f)
				   `(:field ,f :type :nominal))
				  ((and (listp f)
					(= (length f) 2)
					(keywordp (first f))
					(keywordp (second f)))
				   `(:field ,(first f) :type ,(second f)))
				  ((listp f) f)
				  (t `(:field ,f :type :nominal))))
			  fields)))
    `(:encoding (:tooltip ,(coerce channels 'vector)))))

(defun coord (&key x-domain y-domain (clip t))
  "Return plist clamping axis domains and optionally clipping marks.
Like ggplot2's coord_cartesian: restricts the visible area without
dropping data.

X-DOMAIN / Y-DOMAIN:
  - For quantitative axes: a vector #(min max)
  - For categorical axes: a vector of category names #(\"A\" \"B\" \"C\")

CLIP: if T (default), marks outside the domain are hidden.
      Set to NIL for bar/boxplot where clipping cuts marks."
  `(,@(when clip `(:mark (:clip t)))
    ,@(when x-domain
        `(:encoding (:x (:scale (:domain ,x-domain)))))
    ,@(when y-domain
        `(:encoding (:y (:scale (:domain ,y-domain)))))))

(defun theme (&key width height font background
           (view-stroke :null)
           padding)
  "Return plist for layout and theme settings.

WIDTH, HEIGHT: pixel dimensions
FONT: base font family string — applied to the entire chart via config.font
BACKGROUND: CSS color string for the chart background
VIEW-STROKE: stroke around the view rectangle; :null (default) removes it, a string sets a CSS color, NIL omits the property entirely
PADDING: padding in pixels (number) or plist (:left :right :top :bottom)

Like ggplot2's coord_cartesian: restricts the visible area without
dropping data.

X-DOMAIN / Y-DOMAIN:
  - For quantitative axes: a vector #(min max)
  - For categorical axes: a vector of category names #(\"A\" \"B\" \"C\")

CLIP: if T (default), marks outside the domain are hidden.
      Set to NIL for bar/boxplot where clipping cuts marks."
  (let ((config-props `(,@(when font `(:font ,font))
            ,@(unless (null view-stroke)
                `(:view (:stroke ,view-stroke))))))
    `(,@(when width  `(:width ,width))
      ,@(when height `(:height ,height))
      ,@(when background `(:background ,background))
      ,@(when padding `(:padding ,padding))
      ,@(when config-props `(:config ,config-props)))))
