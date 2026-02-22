;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-lisp; Package: ASDF -*-
;;; Copyright (c) 2026 by Symbolics Pte. Ltd. All rights reserved.

(defsystem "quick-plot"
  :name "Quick Plot"
  :version     "1.0"
  :license     :MS-PL
  :author      "Steve Nunez <steve@symbolics.tech>"
  :long-name   "GGPlot style plotting with Common Lisp"
  :description "A Grammar of Graphics plotting library for Common Lisp providing quick statistical visualizations and layered customization."
  :long-description  #.(uiop:read-file-string
			(uiop:subpathname *load-pathname* "description.text"))
  :homepage    "https://lisp-stat.dev/"
  :source-control (:git "https://github.com/Lisp-Stat/quick-plot.git")
  :bug-tracker "https://github.com/Lisp-Stat/quick-plot/issues"
  :depends-on ("plot/vega")
  :components ((:static-file #:LICENSE)
	       (:file "pkgdcls")
	       (:file "qplot")
	       (:file "gg")
	       (:file "geom")))
