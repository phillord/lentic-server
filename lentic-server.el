;;; lentic-server.el --- Web Server for Emacs Literate Source

;;; Header:

;; This file is not part of Emacs

;; Author: Phillip Lord <phillip.lord@newcastle.ac.uk>
;; Maintainer: Phillip Lord <phillip.lord@newcastle.ac.uk>
;; Version: 0.1
;; Package-Requires: ((lentic "0.8")(web-server "0.1.1"))

;; The contents of this file are subject to the GPL License, Version 3.0.

;; Copyright (C) 2015, Phillip Lord, Newcastle University

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Serves up lentic files as web documents.

;;; Code:

;; #+begin_src emacs-lisp
(require 'lentic-doc)
(require 'web-server)

(defvar lentic-server-doc t)

(defvar lentic-server--server nil)

;;;###autoload
(defun lentic-server-start ()
  (interactive)
  (setq lentic-server--server
        (ws-start
         (lambda (request)
           (with-slots (process headers) request
             (-let* (((_ package . _)
                      (f-split (cdr (assoc :GET headers))))
                     )
               (if (not (-contains? (lentic-doc-all-lentic-features)
                                    package))
                   (ws-send-404 process)
                 (lentic-doc-ensure-doc package)
                 (ws-send-file process
                               (lentic-doc-package-doc-file package))))))
         9010)))

;;;###autoload
(defun lentic-server-stop ()
  (interactive)
  (ws-stop lentic-server--server))

(provide 'lentic-server)
;;; lentic-server.el ends here
;; #+end_src
