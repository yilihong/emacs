;;; init.el --- Patrick Thomson's .emacs file

;;; This file is in the public domain.

;;; Commentary:
;; This should be portable between OS X and sane Linux distros.
;; Cask and Pallet must be installed first.
;; TODO: write a shell script for that.

;;; Code:

;; global requirements
(require 'package)
(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; load melpa and marmalade to start
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize)

;; GLOBAL MODES

;; Automatically indent and insert completing characters.
(electric-indent-mode +1)
(autopair-global-mode +1)

;; ECB
(ecb-minor-mode +1)

;; Track recent files.
(recentf-mode +1)

;; Tabs, please.
(tabbar-mode +1)

;; Flycheck, where possible.
(flycheck-mode +1)

;; Projectile, where possible.
(projectile-global-mode +1)

;; blinky blinky
(blink-cursor-mode +1)

;; autocomplete in minibuffers
(icomplete-mode +1)
(setq-default icicle-expand-input-to-common-match 4)

;; delete selections, like LITERALLY EVERYWHERE ELSE
(delete-selection-mode +1)

;; y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; KEYBOARD SHORTCUTS

;; C-; is my namespace
(global-set-key (kbd "C-;") nil)

;; C-; r is recentf
(global-set-key (kbd "C-; r") 'recentf-open-files)

;; C-; g is git
(global-set-key (kbd "C-; g") 'magit-status)

;; C-; f is git-grep
(autoload 'magit-grep "magit" "Grep for files" t)
(global-set-key (kbd "C-; f") 'magit-grep)

;; C-; e edits my .emacs setup
(global-set-key (kbd "C-; e")
                (lambda ()
                  (interactive)
                  (find-file "~/.emacs.d/init.el")))

;; C-; l is goto-line
(global-set-key (kbd "C-; l") 'goto-line)

; C-; s spawns a shell
(global-set-key (kbd "C-; s") 'term)

;; Compile current file
(global-set-key (kbd "C-; c") 'compile)

;; Goto next error
(global-set-key (kbd "C-; d") 'flycheck-tip-cycle)

;; Find file in project
(global-set-key (kbd "C-; p") 'projectile-find-file)

;; SETTINGS

;; don't alarm bell when going to end of document
(defun my-bell-function ()
  "Prevents the bell from going off during scroll events."
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

;; oh my god shut up ECB
(setq-default ecb-tip-of-the-day nil)

;; Bar cursor please
(setq-default cursor-type 'bar)

;; please don't scroll so hard
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

(setq-default visual-bell t)

;; NEVER TABS. NEVER
(setq-default indent-tabs-mode nil)

;; fullscreen plz
(unless (eql system-type 'darwin)
  (add-to-list 'default-frame-alist '(fullscreen . fullboth)))

;; emacs kindly stop leaving your trash everywhere
(setq backup-directory-alist
      `((".*" . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/backups" t)))

;; Ensuring Unicode compliance (may not be necessary)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; TABS

(defun my-tabbar-buffer-groups ()
  "Group tabs by whether they are Emacs-local or user-opened.
There are two groups: Emacs buffers (those whose name starts with '*', plus
dired buffers), and the rest.  This works at least with Emacs v24.2 using
tabbar.el v1.7."
   (list (cond ((string-equal "*" (substring (buffer-name) 0 1)) "emacs")
               ((eq major-mode 'dired-mode) "emacs")
               (t "user"))))

(setq-default tabbar-buffer-groups-function 'my-tabbar-buffer-groups)

;; HOOKS AND AUTO-MODES

;; highlight indentation
(add-hook 'prog-mode-hook '(lambda ()
                             (highlight-indentation-mode +1)
                             (highlight-indentation-current-column-mode +1)
                             (auto-complete-mode +1)
                             (toggle-truncate-lines)))

;; execute erlang-mode when encountering .erl files
(add-to-list 'auto-mode-alist '("\\.erl?$" . erlang-mode))

;; haskell
(add-to-list 'auto-mode-alist '("\\.hs?$" . haskell-mode))
(add-hook 'haskell-mode-hook 'haskell-indent-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

;; run go-fmt before saving go code
(add-hook 'go-mode-hook '(lambda ()
                           (add-hook 'before-save-hook 'gofmt-before-save)))

;; erlang indentation is fucky so don't do that

(add-hook 'erlang-mode-hook (lambda () (electric-indent-mode 0)))

;; line numbers and line highlights
(column-number-mode)
(global-linum-mode)
(global-hl-line-mode)
(setq-default linum-format "%d ")

; does these do anything? unclear
(require 'uniquify)
(defconst font-lock-maximum-decoration t)

; default directory for minibuffer
(setq default-directory "~/src")

; blink matching parens
(show-paren-mode)
(setq blink-matching-paren t)

; miscellaneous modes
(icicle-mode t)
(semantic-mode t)
(achievements-mode t)
(setq-default save-place t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes (quote (badger)))
 '(custom-safe-themes (quote ("ad9fc392386f4859d28fe4ef3803585b51557838dbc072762117adad37e83585" "2b5aa66b7d5be41b18cc67f3286ae664134b95ccc4a86c9339c886dfd736132d" default)))
 '(ecb-options-version "2.40")
 '(fci-rule-color "#2e2e2e")
 '(flycheck-clang-include-path (quote ("/Users/Thomson/src/leopold/dablooms/src")))
 '(inhibit-startup-screen t)
 '(vc-annotate-background "#3b3b3b")
 '(vc-annotate-color-map (quote ((20 . "#dd5542") (40 . "#CC5542") (60 . "#fb8512") (80 . "#baba36") (100 . "#bdbc61") (120 . "#7d7c61") (140 . "#6abd50") (160 . "#6aaf50") (180 . "#6aa350") (200 . "#6a9550") (220 . "#6a8550") (240 . "#6a7550") (260 . "#9b55c3") (280 . "#6CA0A3") (300 . "#528fd1") (320 . "#5180b3") (340 . "#6380b3") (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(vc-follow-symlinks nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
