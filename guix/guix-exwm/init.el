;; If you can see the broken fonts in modeline,
;; install necessary fonts by a command below:
;; `M-x all-the-icons-install-fonts`

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/") t)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Font Configuration

(set-face-attribute 'default nil :family "JetBrains Mono")

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
(use-package highlight-indent-guides
  :ensure t)
(use-package tree-sitter
  :ensure t)
(use-package tree-sitter-langs
  :ensure t)

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

(require 'tree-sitter)
(require 'tree-sitter-langs)

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

(shell-command "polybar &")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-battery-mode 1)
(fringe-mode 1)
(setq exwm-workspace-number 4)
(exwm-enable)

