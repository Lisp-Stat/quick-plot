;;; -*- Mode: LISP; Syntax: Ansi-Common-Lisp; Package: QPLOT -*-
;;; Copyright (c) 2026 Symbolics Pte. Ltd. All rights reserved.
;;; Geometry helpers for common Vega-Lite plot types.

(in-package #:qplot)

(defvar *qplot-debug* nil
  "When non-nil, qplot pretty-prints the merged spec before returning the plot object.")

(define-condition qplot-deprecated-warning (simple-warning)
  ()
  (:documentation "Warning signaled when the deprecated QPLOT constructor compatibility seam is used.")
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream
                     "QPLOT is deprecated as a constructor entry point; prefer VEGA:MAKE-PLOT / MAKE-PLOT with the high-level data-plus-fragments path for new code."))))

(defvar *qplot-deprecation-warning-issued-p* nil
  "Tracks whether the QPLOT deprecation warning has already been signaled.")

(defun qplot (name data &rest layers)
  "Deprecated quick plot compatibility wrapper for iterative REPL exploration. Delegates high-level construction to VEGA:MAKE-PLOT and returns the plot object.

EXAMPLE:
  (qplot 'cars vgcars
    `(:title \"HP vs MPG\")
    (scatter-plot :horsepower :miles-per-gallon :filled t)
    (labs :x \"Horsepower\" :y \"MPG\"))

Prefer `(vega:make-plot data ...fragments...)` for new high-level construction
code. NAME is passed through to VEGA:MAKE-PLOT as plot metadata. The returned
plot is not registered, displayed, or bound globally. Use PLOT:PLOT explicitly
to display it.

Bind QPLOT::*QPLOT-DEBUG* to T to see the merged spec before the plot object
is returned."
  (unless *qplot-deprecation-warning-issued-p*
    (setf *qplot-deprecation-warning-issued-p* t)
    (warn 'qplot-deprecated-warning))
  (let* ((spec (apply #'vega:merge-plists
                      `(:data (:values ,data))
                      layers))
         (plot (apply #'vega:make-plot data :name name layers)))
    (when *qplot-debug*
      (pprint spec))
    plot))
