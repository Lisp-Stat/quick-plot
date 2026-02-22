;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2026 by Symbolics Pte. Ltd. All rights reserved.

(uiop:define-package #:qplot
  (:use :cl)
  (:export #:qplot)
  (:documentation "QPLOT provides a quick plotting interface for generating common statistical visualizations with minimal configuration, offering a concise API for rapid exploratory data analysis in Common Lisp."))

(uiop:define-package #:gg
  (:use :cl)
  (:export #:label #:axes #:coord #:theme #:tooltip)
  (:documentation "GG provides a grammar-of-graphics layer for customizing plot aesthetics, including labels, axes, coordinate systems, themes, and tooltips, enabling fine-grained control over visualization appearance and layout."))

(uiop:define-package #:geom
  (:use :cl)
  (:export #:histogram
           #:bar
	   #:point
	   #:line
	   #:box-plot)
  (:documentation "GEOM defines geometric objects for statistical plots, providing constructors for histograms, bar charts, scatter points, lines, and box plots used to represent data visually."))

