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
    (assert-equalp `(:values ,data) (getf (plot-spec plot) :data))))

(deftest qplot-does-not-auto-register (quick-plot)
  "qplot does not add the constructed plot to the public registry."
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
    (assert-false (find-plot 'registry-check))))

(deftest qplot-does-not-bind-global-variable (quick-plot)
  "qplot does not define or bind the supplied name as a global variable."
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
        (makunbound sym)))))
