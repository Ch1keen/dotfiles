(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Font Configuration

(set-face-attribute 'default nil :family "D2Coding")

;; Some built-in customization

(setq inhibit-startup-screen t)
(global-display-line-numbers-mode)


;; Package list

(use-package zenburn-theme
  :ensure t)
(use-package tex
  :ensure auctex)
(use-package org
  :ensure t)
(use-package magit
  :ensure t)
(use-package all-the-icons
  :ensure
  :if (display-graphic-p))
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package parrot
  :ensure t
  :config (parrot-mode))

(require 'highlight-indent-guides)
(use-package highlight-indent-guides
  :ensure t
  :custom (highlight-indent-guides-method 'character)
          (highlight-indent-guides-responsive 'top)
          (highlight-indent-guides-auto-enabled nil)
  :init (set-face-foreground 'highlight-indent-guides-top-character-face "cyan")
        (set-face-foreground 'highlight-indent-guides-character-face "dimgray")	  
  :hook (prog-mode . highlight-indent-guides-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(load-theme 'zenburn t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("~/Documents/private-latex/toby.org"))
 '(package-selected-packages '(magit zenburn-theme use-package auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
