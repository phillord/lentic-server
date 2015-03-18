(require 'ert)
(require 'lentic-server)


(ert-deftest test-lentic-server-start ()
  (should
   (progn (lentic-server-start)
          (lentic-server-stop))))
