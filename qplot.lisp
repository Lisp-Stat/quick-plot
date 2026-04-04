;;; -*- Mode: LISP; Syntax: Ansi-Common-Lisp; Package: QPLOT -*-
;;; Copyright (c) 2026 Symbolics Pte. Ltd. All rights reserved.
;;; Geometry helpers for common Vega-Lite plot types.

(in-package #:qplot)

(defvar *qplot-debug* nil
  "When non-nil, qplot pretty-prints the merged spec before returning the plot object.")

(defun qplot (name data &rest layers)
  "Quick plot for iterative REPL exploration. Merges LAYERS into a Vega-Lite spec, constructs a plot object, and returns it.

EXAMPLE:
  (qplot 'cars vgcars
    `(:title \"HP vs MPG\")
    (scatter-plot :horsepower :miles-per-gallon :filled t)
    (labs :x \"Horsepower\" :y \"MPG\"))

NAME is passed through to VEGA:MAKE-PLOT-FROM-SPEC as the plot name. The
returned plot is not registered, displayed, or bound globally. Use PLOT:PLOT
explicitly to display it.

Bind QPLOT::*QPLOT-DEBUG* to T to see the merged spec before the plot object
is returned."
  (let* ((spec (apply #'vega:merge-plists
                      `(:data (:values ,data))
                      layers))
         (plot (vega:make-plot-from-spec spec :name name)))
    (when *qplot-debug*
      (pprint spec))
    plot))
