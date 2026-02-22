;;; -*- Mode: LISP; Syntax: Ansi-Common-Lisp; Base: 10; Package: QPLOT -*-
;;; Copyright (c) 2026 Symbolics Pte. Ltd. All rights reserved.
;;; Geometry helpers for common Vega-Lite plot types.

(in-package #:qplot)

(defvar *qplot-debug* nil
  "When non-nil, qplot pretty-prints the merged spec before rendering.")

(defun qplot (name data &rest layers)
  "Quick plot for iterative REPL exploration. Merges LAYERS into a Vega-Lite spec, defines/redefines the named plot, renders it, and returns the plot object.

EXAMPLE:
  (qplot 'cars vgcars
    `(:title \"HP vs MPG\")
    (scatter-plot :horsepower :miles-per-gallon :filled t)
    (labs :x \"Horsepower\" :y \"MPG\"))

NAME is a symbol. The plot is registered in VEGA:*ALL-PLOTS* and bound as a special variable, exactly like DEFPLOT. Re-using the same NAME overwrites the previous definition.

Bind QPLOT::*QPLOT-DEBUG* to T to see the merged spec before rendering."
  (let* ((spec (apply #'vega:merge-plists
                      `(:data (:values ,data))
                      layers))
         (plot (vega::%defplot name spec)))
    (when *qplot-debug*
      (pprint spec))
    (proclaim `(special ,name))
    (setf (symbol-value name) plot)
    (setf (gethash (string name) vega::*all-plots*) plot)
    (plot:plot plot)
    plot))
