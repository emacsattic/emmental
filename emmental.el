;; emmental.el -- take snapshots with Emacs

;;; Commentary:
;; 

;; emmental.el is an emacs interface to your webcam.
;; An Emmentaler is a type of cheese.

;; currently emmental.el uses the fswebcam v4l frontend.

;; You can use emmental.el with org-mode to embedd snapshots in your org files,
;; or standalone

;;; Code:

(defcustom emmental-capture-dir "/tmp/fswebcam"
  "where to store images")

(defun emmental-capture (video-device image-prefix image-index)
  "Get an image from VIDEO-DEVICE with IMAGE-PREFIX."
  (let*
      ((default-directory emmental-capture-dir)
       (image-file-name (format "%s/%s-%s.jpg" emmental-capture-dir image-prefix image-index)))
    (mkdir default-directory t)
    ;;I needed LD_PRELOAD on an old Fedora but I think that is a distro bug
    ;;"LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so fswebcam -v -d /dev/video%s -i0 %s/%s.jpg"
    (process-file-shell-command (format "fswebcam -v -d /dev/video%s -i0 %s"
                                        video-device image-file-name)
                                "" "*emmental*"  )
    image-file-name))


(setq emmental-image-index 0)

(defun emmental-capture-and-preview (video-device image-prefix)
  "Get an image from VIDEO-DEVICE with IMAGE-PREFIX.
Preview it"
  (interactive (list 0 "emmental"))
  (let* ((image-file-name (emmental-capture video-device image-prefix emmental-image-index)))

    (pop-to-buffer (get-buffer-create "*emmental preview*"))
    (insert image-file-name)
    (insert-image (create-image image-file-name))
    (setq emmental-image-index (+ 1 emmental-image-index))))

(defun org-emmental ()
  (interactive)
  (let* ((image-file-name (emmental-capture 0 "org-emmental" emmental-image-index)))

    (insert (format "[[file://%s]]" image-file-name))

    (setq emmental-image-index (+ 1 emmental-image-index))))

(provide 'emmental)

;;; emmental.el ends here
