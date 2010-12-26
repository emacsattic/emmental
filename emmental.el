;; emmental.el -- take snapshots with Emacs

;;; Commentary:
;; 

;; emmental.el is an emacs interface to your webcam.
;; An Emmentaler is a type of cheese.

;; currently emmental.el uses the fswebcam v4l frontend.

;;; Code:

(defcustom emmental-capture-dir "/tmp/fswebcam"
  "where to store images")

(defun emmental-capture (video-device image-prefix)
  "Get an image from VIDEO-DEVICE with IMAGE-PREFIX."
  (let*
      ((default-directory emmental-capture-dir))
    (mkdir default-directory t)
    (process-file-shell-command (format "LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so fswebcam -v -d /dev/video%s -i0 %s/%s.jpg"
                                        video-device default-directory image-prefix)
                                "" "*emmental*"  )))

(defun emmental-capture-and-preview (video-device image-prefix)
  "Get an image from VIDEO-DEVICE with IMAGE-PREFIX.
Preview it"
  (emmental-capture video-device image-prefix)
  (insert-image (create-image (format "%s/%s.jpg" emmental-capture-dir image-prefix))))

;; The original use case for this library was the code snippet below.
;; it takes a bunch of snaps from several different webcams and inserts them.

;; (progn
;;   (pop-to-buffer "emmental")
;;   (erase-buffer)
;;   (clear-image-cache)
;;   (emmental-capture-and-preview "0" "0")
;;   (emmental-capture-and-preview "2" "1")
;;   (emmental-capture-and-preview "1" "2")
;;   )

(provide 'emmental)

;;; emmental.el ends here
