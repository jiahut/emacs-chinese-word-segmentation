;;; cns-evil.el --- Chinese word segmentation library based on Jieba.  -*- lexical-binding: t; -*-

(defun cns-evil-setup ()
  (evil-define-motion cns-evil-forward-word-begin (count &optional bigword)
    "Move the cursor to the beginning of the next word using cns."
    :type exclusive
    (evil-signal-at-bob-or-eob count)
    (let ((orig (point)))
      (cns-forward-word count)
      ;; 这里的边界值需要加1
      (when (and (eolp) (= (point) (+ orig 1)))
        (evil-next-line)
        (evil-first-non-blank))))

  (evil-define-motion cns-evil-backward-word-begin (count &optional bigword)
    "Move the cursor to the beginning of the previous word using cns."
    :type exclusive
    (let ((orig (point)))
      (evil-signal-at-bob-or-eob (- (or count 1)))
      (cns-backward-word count)
      ;; (when (= (point) orig)
      ;;   (unless (bobp)
      ;;     (backward-word)))
      ))

  (evil-define-motion cns-evil-forward-word-end (count &optional bigword)
    "Move the cursor to the end of the next word using cns."
    :type inclusive
    (evil-signal-at-bob-or-eob count)
    (let ((orig (point)))
      (cns-forward-word count)
      ;; (when (and (not (eolp)) (> (- (point) orig) 1))
      ;;   (backward-char 1))
      (when (and (eolp) (= (point) (+ orig 1)))
        (evil-next-line)
        (evil-first-non-blank))
      ))

  (evil-define-motion cns-evil-backward-word-end (count &optional bigword)
    "Move the cursor to the end of the previous word using cns."
    :type inclusive
    (let ((orig (point)))
      (evil-signal-at-bob-or-eob (- (or count 1)))
      (cns-backward-word count)
      ;; (when (= (point) orig)
      ;;   (unless (bobp)
      ;;     (backward-word)))
      ))

  (evil-define-text-object cns-evil-a-word (count &optional beg end type)
    "Select a word including leading/trailing whitespace using cns."
    (evil-range
     (progn
       (cns-evil-backward-word-begin count)
       (point))
     (progn
       (cns-evil-forward-word-end count)
       (point))
     type))

  (evil-define-text-object cns-evil-inner-word (count &optional beg end type)
    "Select inner word excluding leading/trailing whitespace using cns."
    (evil-range
     (progn
       (cns-evil-backward-word-begin count)
       (point))
     (progn
       (cns-evil-forward-word-end count)
       (point))
     type))

  (define-key evil-outer-text-objects-map "w" 'cns-evil-a-word)
  (define-key evil-inner-text-objects-map "w" 'cns-evil-inner-word)

  (define-key evil-motion-state-map "w" 'cns-evil-forward-word-begin)
  (define-key evil-motion-state-map "b" 'cns-evil-backward-word-begin)
  (define-key evil-motion-state-map "e" 'cns-evil-forward-word-end)
  (define-key evil-motion-state-map "ge" 'cns-evil-backward-word-end))

(defun cns-evil-teardown ()
  (define-key evil-outer-text-objects-map "w" 'evil-a-word)
  (define-key evil-inner-text-objects-map "w" 'evil-inner-word)

  (define-key evil-motion-state-map "w" 'evil-forward-word-begin)
  (define-key evil-motion-state-map "b" 'evil-backward-word-begin)
  (define-key evil-motion-state-map "e" 'evil-forward-word-end)
  (define-key evil-motion-state-map "ge" 'evil-backward-word-end))

(add-hook 'cns-mode-hook 'cns-evil-setup)
(add-hook 'cns-mode-exit-hook 'cns-evil-teardown)

(provide 'cns-evil)

;;; cns-evil.el ends here
