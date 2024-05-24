# emacs-chinese-word-segmentation

基于 [结巴分词](https://github.com/yanyiwu/cppjieba) 的 Emacs 中文分词
工具，实现了以中文词语为单位的移动和编辑。支持 Linux、Cygwin、Windows
和 Android/Termux 平台。目前 Windows 平台支持是通过调用 WSL 或 Cygwin
进程实现的（需要在 WSL 或 Cygwin 中编译）。

## changelog

1. 修复直接指定program
2. 更好的适配 evil


## 在evil 模式适配

``` elisp
(use-package emacs
  :after evil
  :config
  (add-to-list 'load-path "c:/emacs-chinese-word-segmentation")
  (setq cns-prog "c:/emacs-chinese-word-segmentation/cnws.exe")
  (setq cns-dict-directory "c:/emacs-chinese-word-segmentation/cppjieba/dict")

  (setq cns-recent-segmentation-limit 20) ; default is 10
  (setq cns-debug t) ; disable debug output, default is t
  (require 'cns nil t)
  (when (featurep 'cns)
    (add-hook 'find-file-hook 'cns-auto-enable))
  (require 'cns-evil))
```

## 原理

将光标所在的中文句子发送到外部程序实时进行中文分词，分词结果返回给
Emacs，只用到分词后的每个词组的长度（如 `["中文", "分词"]: 2 2` 只保留
`2 2`）。实际上任何输出该格式（仅需要以空格分隔的词组长度列表）分词结
果的中文分词软件都可以配合本软件包使用，只需设置好
`cns-process-shell-command`。

## 编译

需要先安装 C++ 编译器（ gcc/g++ 或 clang）和 make：

```sh
git clone $this_repo
cd $this_repo
git submodule update --init --recursive
# using g++
make
# using clang++
env CXX=clang++ make
```

将生成 `cnws` 可执行文件（Cygwin 平台为 `cnws.exe`）。

## 使用示例

```elisp
(add-to-list 'load-path "/path/to/this-library")
(setq cns-prog "/path/to/this-library/cnws")
(setq cns-dict-directory "/path/to/this-library/cppjieba/dict")

;; 若使用其它中文分词软件, 需要设置 cns-process-shell-command:
;; (setq cns-process-shell-command "word_segmentation_program arg1 arg2...")

;; Windows 平台（指官方 windows 版 Emacs）请先检查或设置
;; cns-cmdproxy-shell-path，默认优先选择 WSL 环境，因为编译后分词软件
;; 的运行速度在 WSL 中比 Cygwin 速度快，若选择使用 Cygwin 平台作为编译
;; 环境，需要手工设置好 cns-cmdproxy-shell-path。
;;
;; (setq cns-cmdproxy-shell-path "wsl.exe bash")
;; 或
;; (setq cns-cmdproxy-shell-path "C:/cygwin64/bin/bash.exe")

(setq cns-recent-segmentation-limit 20) ; default is 10
(setq cns-debug nil) ; disable debug output, default is t
(require 'cns nil t)
(when (featurep 'cns)
  (add-hook 'find-file-hook 'cns-auto-enable))
```

手动开启 minor mode：<kbd>M-x</kbd> `cns-mode` <kbd>RET</kbd>，或者开
启 `global-cns-mode`.

## 按键绑定

```
+---------------+----------------------+--------------------------+
| key binding   | default command      | cns-mode command         |
+---------------+----------------------+--------------------------+
| M-b           | (backward-word)      | (cns-backward-word)      |
| M-f           | (forward-word)       | (cns-forward-word)       |
| C-<backspace> | (backward-kill-word) | (cns-backward-kill-word) |
| M-DEL         | (backward-kill-word) | (cns-backward-kill-word) |
| C-<delete>    | (kill-word)          | (cns-kill-word)          |
| M-d           | (kill-word)          | (cns-kill-word)          |
| M-t           | (transpose-words)    | (cns-transpose-words)    |
+---------------+----------------------+--------------------------+
```

详见 `cns.el` 中的注释。
