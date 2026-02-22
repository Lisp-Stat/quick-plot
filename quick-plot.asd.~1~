;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-lisp; Package: ASDF -*-
;;; Copyright (c) 2023 by Symbolics Pte. Ltd. All rights reserved.

(defsystem "smoothers"
  :name "Smoothers"
  :version     "1.0"
  :license     :MS-PL
  :author      "Steve Nunez <steve@symbolics.tech>"
  :long-name   "Statistical Smoothing Functions"
  :description "Statistical methods to create approximating functions that attempt to capture important patterns in the data, while leaving out noise or other fine-scale structures/rapid phenomena."
  :long-description  #.(uiop:read-file-string
			(uiop:subpathname *load-pathname* "description.text"))
  :homepage    "https://lisp-stat.dev/"
  :source-control (:git "https://github.com/Lisp-Stat/smoothers.git")
  :bug-tracker "https://github.com/Lisp-Stat/smoothers/issues"
  :depends-on ("alexandria"
               "alexandria+"
	       "array-operations"
	       "num-utils"
	       "lla")
  :components ((:file "pkgdcls")
	       (:static-file #:LICENSE)
	       (:file "lowess")))
