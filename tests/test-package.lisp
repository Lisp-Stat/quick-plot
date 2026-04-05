;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2026 by Symbolics Pte. Ltd. All rights reserved.

(in-package :cl-user)

(uiop:define-package :quick-plot-tests
  (:documentation "Regression tests for quick-plot")
  (:use :common-lisp
        :clunit)
  (:import-from :qplot
                #:qplot)
  (:import-from :plot
                #:plot-name
                #:plot-data
                #:plot-spec)
  (:import-from :vega
                #:find-plot
                #:list-plots)
  (:export :run-tests))
