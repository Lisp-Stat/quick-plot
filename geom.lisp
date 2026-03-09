;;; -*- Mode: LISP; Syntax: Ansi-Common-Lisp; Base: 10; Package: GEOM -*-
;;; Copyright (c) 2026 Symbolics Pte. Ltd. All rights reserved.
;;; Geometry helpers for common Vega-Lite plot types.

(in-package #:geom)

;;; Following the ggplot2 design, geom functions handle marks and
;;; encodings only — they return plists that are spliced into a plot
;;; spec via ,@.  Axis titles, labels, themes, and scales are
;;; concerns of the plot-level specification and should not be set
;;; here.  Users needing fine-grained control beyond what these
;;; helpers provide can use the full Vega-Lite grammar directly.
;;;
;;; Convention for color/shape/size parameters:
;;;   keyword  → field name  → goes into :encoding  (e.g. :origin)
;;;   string   → literal CSS → goes into :mark      (e.g. "steelblue")
;;;   number   → literal     → goes into :mark or :value as appropriate

(defun histogram (field &key
              (orient :vertical)
              (aggregate :count)
              (bin t)
              (color "steelblue")
              (group nil)
              (stack nil)
              (opacity nil)
              (bin-spacing nil)
              (corner-radius-end nil))
  "Return plist specifying a histogram encoding.

FIELD: the quantitative field to bin
ORIENT: :vertical (default) or :horizontal
AGGREGATE: a vega-lite aggregation operator (default :count)
BIN: a vega-lite binning spec; T for default binning, or a plist e.g. (:maxbins 10)
COLOR: a CSS color string (default \"steelblue\") for a fixed mark color,
       or a keyword field name for nominal color encoding.
       Ignored when GROUP is set.
GROUP: optional nominal field for stacked/layered histograms
STACK: NIL (default, vega-lite stacks automatically when GROUP is set), :normalize for 100% stacked, or :null for layered
OPACITY: opacity value between 0 and 1 (useful for layered histograms)
BIN-SPACING: pixel gap between bars; 0 for gapless, NIL for vega-lite default (1)
CORNER-RADIUS-END: radius in pixels for the bar ends"
  (let* ((bin-enc `(:bin ,bin :field ,field))
     (agg-enc `(:aggregate ,aggregate))
     (agg-with-stack (if stack
                 `(,@agg-enc :stack ,(if (eql stack :null) :null stack))
                 agg-enc))
     (x-enc (if (eql orient :vertical) bin-enc agg-with-stack))
     (y-enc (if (eql orient :vertical) agg-with-stack bin-enc)))
    `(:mark (:type :bar
           ,@(unless group
               (when (stringp color) `(:color ,color)))
           ,@(when bin-spacing `(:bin-spacing ,bin-spacing))
           ,@(when corner-radius-end
               `(:corner-radius-end ,corner-radius-end)))
      :encoding (:x ,x-enc
         :y ,y-enc
         ,@(cond (group
              `(:color (:field ,group :type :nominal)))
             ((keywordp color)
              `(:color (:field ,color :type :nominal))))
         ,@(when opacity
             `(:opacity (:value ,opacity)))))))

(defun bar (x y &key
          (orient :vertical)
          (aggregate nil)
          (color "steelblue")
          (group nil)
          (stack nil)
          (opacity nil)
          (corner-radius-end nil))
  "Return plist specifying a bar chart encoding.

X: the categorical (nominal/ordinal) field
Y: the quantitative field
ORIENT: :vertical (default, categories on x) or :horizontal (categories on y)
AGGREGATE: optional vega-lite aggregation for the quantitative field (e.g. :sum :mean)
COLOR: a CSS color string (default \"steelblue\") for a fixed mark color,
       or a keyword field name for nominal color encoding.
       Ignored when GROUP is set.
GROUP: optional nominal field for stacked/grouped bar charts
STACK: NIL (default), :normalize for 100%%, or :null for layered
OPACITY: opacity value between 0 and 1
CORNER-RADIUS-END: radius in pixels for the bar ends"
  (let* ((cat-enc `(:field ,x :type :nominal))
     (quant-enc `(:field ,y :type :quantitative
                 ,@(when aggregate `(:aggregate ,aggregate))
                 ,@(when stack
                 `(:stack ,(if (eql stack :null) :null stack)))))
     (x-enc (if (eql orient :vertical) cat-enc quant-enc))
     (y-enc (if (eql orient :vertical) quant-enc cat-enc)))
    `(:mark (:type :bar
           ,@(unless group
               (when (stringp color) `(:color ,color)))
           ,@(when corner-radius-end
               `(:corner-radius-end ,corner-radius-end)))
      :encoding (:x ,x-enc
         :y ,y-enc
         ,@(cond (group
              `(:color (:field ,group :type :nominal)))
             ((keywordp color)
              `(:color (:field ,color :type :nominal))))
         ,@(when opacity
             `(:opacity (:value ,opacity)))))))

(defun box-plot (field &key
             (category nil)
             (orient :horizontal)
             (extent 1.5)
             (color nil)
             (size nil)
             (opacity nil)
             (legend nil)
             (zero-scale nil))
  "Return plist specifying a box plot encoding.

FIELD: the quantitative field to summarize
CATEGORY: optional nominal field for 2D box plots
ORIENT: :horizontal (default) or :vertical
EXTENT: whisker extent — 1.5 (Tukey default), a number, or \"min-max\"
COLOR: a CSS color string for a fixed mark color,
       or a keyword field name for nominal color encoding.
       When CATEGORY is set and COLOR is nil, defaults to encoding by CATEGORY.
SIZE: box/median tick size value
OPACITY: opacity value between 0 and 1
LEGEND: if non-NIL, include a color legend; default NIL suppresses it
ZERO-SCALE: if NIL (default), set scale zero to false for the quantitative axis"
  (let* ((scale (unless zero-scale '(:zero :false)))
     (quant-enc `(:field ,field :type :quantitative
                 ,@(when scale `(:scale ,scale))))
     (cat-enc (when category
            `(:field ,category :type :nominal)))
     (x-enc (if (eql orient :horizontal) quant-enc cat-enc))
     (y-enc (if (eql orient :horizontal) cat-enc quant-enc)))
    `(:mark (:type :boxplot :extent ,extent
           ,@(when size `(:size ,size))
           ,@(when (stringp color) `(:color ,color)))
      :encoding (,@(when x-enc `(:x ,x-enc))
         ,@(when y-enc `(:y ,y-enc))
         ,@(when (keywordp color)
             `(:color (:field ,color :type :nominal
                      ,@(unless legend '(:legend :null)))))
         ,@(when (and category (not color))
             `(:color (:field ,category :type :nominal
                      ,@(unless legend '(:legend :null)))))
         ,@(when opacity
             `(:opacity (:value ,opacity)))))))

(defun point (x y &key
            (color nil)
            (shape nil)
            (size nil)
            (opacity nil)
            (filled nil)
            (zero-scale t))
  "Return plist specifying a scatter plot encoding.

X: the quantitative field for the x-axis
Y: the quantitative field for the y-axis
COLOR: a keyword field name for nominal color encoding (e.g. :origin),
       or a CSS color string for a fixed mark color (e.g. \"steelblue\").
SHAPE: a keyword field name for shape encoding (e.g. :origin),
       or a string shape name for a fixed mark shape (e.g. \"diamond\")
SIZE: a number for fixed point size (pixel area),
      or a keyword field name for a bubble plot
OPACITY: opacity value between 0 and 1
FILLED: if non-NIL, fill the point marks (default NIL, hollow points)
ZERO-SCALE: if T (default), include zero; NIL sets scale zero to false"
  (let* ((scale (unless zero-scale '(:scale (:zero :false))))
     (x-enc `(:field ,x :type :quantitative ,@scale))
     (y-enc `(:field ,y :type :quantitative ,@scale)))
    `(:mark (:type :point
           ,@(when filled '(:filled t))
           ,@(when (stringp color) `(:color ,color))
           ,@(when (stringp shape) `(:shape ,shape)))
      :encoding (:x ,x-enc
         :y ,y-enc
         ,@(when (keywordp color)
             `(:color (:field ,color :type :nominal)))
         ,@(when (keywordp shape)
             `(:shape (:field ,shape :type :nominal)))
         ,@(when (numberp size)
             `(:size (:value ,size)))
         ,@(when (keywordp size)
             `(:size (:field ,size :type :quantitative)))
         ,@(when opacity
             `(:opacity (:value ,opacity)))))))

(defun line (x y &key (x-type :quantitative) (y-type :quantitative)
                      color size opacity stroke-width stroke-dash
                      order interpolate point aggregate)
  "Return a plist for a Vega-Lite line mark with x/y encodings.
X and Y are field-name keywords.  Optional arguments:

  :x-type       — Vega-Lite type for the x channel:
                   :quantitative (default), :temporal, :ordinal, :nominal
  :y-type       — Vega-Lite type for the y channel:
                   :quantitative (default), :temporal, :ordinal, :nominal
  :color        — keyword field name for nominal color encoding,
                   or a CSS color string for a fixed line color
  :size         — keyword field name for stroke-width encoding,
                   or a number for fixed stroke width
  :opacity      — number 0–1 for line opacity
  :stroke-width — number for fixed stroke width (mark property)
  :stroke-dash  — vector for dash pattern, e.g. #(4 2)
  :order        — keyword field name to control draw order
                   (default: x order)
  :interpolate  — interpolation method keyword, e.g.
                   :linear :monotone :step :basis :cardinal
  :point        — t to overlay point marks on the line, or a plist
                   of point mark properties
  :aggregate    — aggregation operator for the y channel, e.g. :mean :sum :count
                    Applied inline in the y encoding, matching Vega-Lite's
                    implicit aggregation pattern.

Examples:

  (line :date :price :x-type :temporal)
  (line :date :price :x-type :temporal :color :symbol)
  (line :date :price :color \"steelblue\")
  (line :date :price :x-type :temporal :interpolate :monotone :point t)
  (line :year :population :stroke-dash #(4 2) :opacity 0.8)"

  (let ((mark-props `(,@(when interpolate `(:interpolate ,interpolate))
                      ,@(when point
                          `(:point ,(if (eq point t) t point)))
                      ,@(when stroke-width `(:stroke-width ,stroke-width))
                      ,@(when stroke-dash `(:stroke-dash ,stroke-dash))
                      ,@(when (stringp color) `(:color ,color))
                      ,@(when (and opacity (not (keywordp color)))
                          `(:opacity ,opacity)))))
    `(:mark ,(if mark-props
                 `(:type :line ,@mark-props)
                 :line)
      :encoding (:x (:field ,x :type ,x-type)
                 :y (:field ,y :type ,y-type
                     ,@(when aggregate `(:aggregate ,aggregate)))  ; ← ADD THIS
                 ,@(when (keywordp color)
                     `(:color (:field ,color :type :nominal)))
                 ,@(when (and opacity (keywordp color))
                     `(:opacity (:value ,opacity)))
                 ,@(when (keywordp size)
                     `(:size (:field ,size :type :quantitative)))
                 ,@(when (numberp size)
                     `(:size (:value ,size)))
                 ,@(when order
                     `(:order (:field ,order)))))))

(defun error-bar (field &key
                        (extent :stdev)   ; :stdev :stderr :ci :iqr or a number
                        (orient :vertical) ; :vertical (y-errors) or :horizontal (x-errors)
                        (category nil)    ; nominal field for x/y grouping
                        (color nil)       ; keyword → field encoding, string → literal CSS
                        (opacity nil)
                        (legend nil)
                        (thickness nil)   ; stroke width of the error bar rule
                        (ticks nil))      ; t to show tick marks at whisker ends
  "Return plist specifying an error bar encoding.

FIELD: the quantitative field whose spread is shown.
EXTENT: summary statistic for the whiskers.
  :stdev  — ±1 standard deviation (default)
  :stderr — ±1 standard error
  :ci     — 95% confidence interval
  :iqr    — interquartile range
  number  — symmetric extent in data units
ORIENT: :vertical (default, error bars run along y-axis)
        or :horizontal (error bars run along x-axis)
CATEGORY: optional nominal field used as the opposite axis for grouping.
COLOR: a keyword field name for nominal color encoding,
       or a CSS color string for a fixed mark color.
       When CATEGORY is set and COLOR is nil, defaults to encoding by CATEGORY.
OPACITY: opacity value between 0 and 1.
LEGEND: if non-NIL, include a color legend; default NIL suppresses it.
THICKNESS: stroke width of the error bar rule in pixels.
TICKS: if non-NIL, show tick marks at whisker ends.

Examples:

  (errorbar :len)
  (errorbar :len :category :supp :extent :stdev)
  (errorbar :len :category :dose :extent :ci :color :supp)
  (errorbar :len :extent :stderr :orient :horizontal :color \"steelblue\")"
  (let* ((quant-enc `(:field ,field :type :quantitative))
         (cat-enc   (when category
                      `(:field ,category :type :nominal)))
         (x-enc (if (eql orient :vertical)  cat-enc   quant-enc))
         (y-enc (if (eql orient :vertical)  quant-enc cat-enc)))
    `(:mark (:type :errorbar
             :extent ,extent
             ,@(when ticks     '(:ticks t))
             ,@(when thickness `(:thickness ,thickness))
             ,@(when (stringp color) `(:color ,color)))
      :encoding (,@(when x-enc `(:x ,x-enc))
                 ,@(when y-enc `(:y ,y-enc))
                 ,@(when (keywordp color)
                     `(:color (:field ,color :type :nominal
                               ,@(unless legend '(:legend :null)))))
                 ,@(when (and category (not color))
                     `(:color (:field ,category :type :nominal
                               ,@(unless legend '(:legend :null)))))
                 ,@(when opacity
                     `(:opacity (:value ,opacity)))))))
