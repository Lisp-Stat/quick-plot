;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: QUICK-PLOT-TESTS -*-
;;; Copyright (c) 2026 by Symbolics Pte. Ltd. All rights reserved.

(in-package :quick-plot-tests)

(defun run-tests (&optional (report-progress t))
  "Run all quick-plot test suites. Returns the clunit-report object."
  (let ((*print-pretty* t)
        (clunit:*test-output-stream* *standard-output*))
    (run-suite 'quick-plot :report-progress report-progress)))

(defsuite quick-plot ())

(deftest harness-sanity (quick-plot)
  "Validates that the quick-plot test harness loads and runs."
  (assert-true t))

(deftest qplot-constructs-plot-object-with-separated-data (quick-plot)
  "qplot returns an object with plot accessors populated from the merged spec."
  (let ((qplot::*qplot-deprecation-warning-issued-p* t))
    (let* ((data #((:x 1 :y 2) (:x 2 :y 3)))
           (plot (qplot 'cars
                        data
                        '(:title "Inline Smoke")
                        '(:mark :point)
                        '(:encoding (:x (:field :x)
                                     :y (:field :y))))))
      (assert-true (stringp (plot-name plot)))
      (assert-true (> (length (plot-name plot)) 0))
      (assert-equalp `(:values ,data) (plot-data plot))
      (assert-equal "Inline Smoke" (getf (plot-spec plot) :title))
      (assert-eql :point (getf (plot-spec plot) :mark))
      (assert-equalp `(:values ,data) (getf (plot-spec plot) :data)))))

(deftest qplot-does-not-auto-register (quick-plot)
  "qplot does not add the constructed plot to the public registry."
  (let ((qplot::*qplot-deprecation-warning-issued-p* t))
    (let* ((data #((:x 10 :y 20)))
           (before (list-plots))
           (plot (qplot 'registry-check
                        data
                        '(:title "No Registry")
                        '(:mark :point)
                        '(:encoding (:x (:field :x)
                                     :y (:field :y)))))
           (after (list-plots)))
      (assert-true (stringp (plot-name plot)))
      (assert-true (> (length (plot-name plot)) 0))
      (assert-equal before after)
      (assert-false (find-plot 'registry-check)))))

(deftest qplot-does-not-bind-global-variable (quick-plot)
  "qplot does not define or bind the supplied name as a global variable."
  (let ((qplot::*qplot-deprecation-warning-issued-p* t))
    (let* ((sym (intern "QPLOT-GLOBAL-BINDING-CHECK" (find-package :quick-plot-tests)))
           (data #((:x 1 :y 1))))
      (when (boundp sym)
        (makunbound sym))
      (unwind-protect
           (progn
             (assert-false (boundp sym))
             (qplot sym
                    data
                    '(:title "No Global Binding")
                    '(:mark :point)
                    '(:encoding (:x (:field :x)
                                 :y (:field :y))))
             (assert-false (boundp sym)))
        (when (boundp sym)
          (makunbound sym))))))

(deftest qplot-signals-deprecation-warning-once (quick-plot)
  "qplot signals one deprecation warning directing callers to VEGA:MAKE-PLOT on the high-level path."
  (let ((warning nil)
        (warning-count 0))
    (handler-bind ((qplot::qplot-deprecated-warning
                     (lambda (condition)
                       (incf warning-count)
                       (setf warning condition)
                       (muffle-warning))))
      (let ((qplot::*qplot-deprecation-warning-issued-p* nil))
        (qplot 'warning-check
               #((:x 1 :y 2))
               '(:title "Warning Check")
               '(:mark :point)
               '(:encoding (:x (:field :x)
                            :y (:field :y))))
        (qplot 'warning-check-2
               #((:x 2 :y 3))
               '(:title "Warning Check 2")
               '(:mark :line)
               '(:encoding (:x (:field :x)
                            :y (:field :y))))))
    (assert-eql 1 warning-count)
    (assert-true warning)
    (assert-true (search "VEGA:MAKE-PLOT" (string-upcase (princ-to-string warning))))
    (assert-true (search "FRAGMENTS" (string-upcase (princ-to-string warning))))))

(deftest qplot-matches-make-plot-high-level-construction (quick-plot)
  "qplot remains a compatibility wrapper over the recommended VEGA:MAKE-PLOT high-level constructor path."
  (let ((qplot::*qplot-deprecation-warning-issued-p* t))
    (let* ((data #((:x 1 :y 2) (:x 2 :y 3)))
           (layers '((:title "Constructor Equivalence")
                     (:mark :point)
                     (:encoding (:x (:field :x)
                                 :y (:field :y)))))
           (compat (apply #'qplot 'compat-check data layers))
           (primary (apply #'vega:make-plot data :name 'compat-check layers)))
      (assert-equal (plot-name primary) (plot-name compat))
      (assert-equalp (plot-data primary) (plot-data compat))
      (assert-equalp (plot-spec primary) (plot-spec compat)))))

(deftest qplot-does-not-display-implicitly (quick-plot)
  "qplot remains construction-only and does not invoke PLOT:PLOT implicitly."
  (let ((display-called nil)
        (original-plot-function (symbol-function 'plot:plot))
        (qplot::*qplot-deprecation-warning-issued-p* t))
    (unwind-protect
         (progn
           (setf (symbol-function 'plot:plot)
                 (lambda (&rest args)
                   (declare (ignore args))
                   (setf display-called t)
                   :display-called))
           (qplot 'display-check
                  #((:x 1 :y 2))
                  '(:title "No Display")
                  '(:mark :point)
                  '(:encoding (:x (:field :x)
                               :y (:field :y))))
           (assert-false display-called))
      (setf (symbol-function 'plot:plot) original-plot-function))))
