# partial.vim

**partial.vim** は囲みの範囲を部分ファイルにして、編集できるようにします。

また、編集した内容を元ファイルに反映できます。
マークダウンのコードブロックや、[dein.vim](https://github.com/Shougo/dein.vim)で使用できるtomlファイル内で記述できるluaや
vim scriptを別ファイルにすることで、LSPやフォーマッターを使えるようにして編集しやすくします。


## Motivation

* コードブロック内の別言語を書く際にLSPやハイライトや補完が効いた環境でコードを書きやすくするためです。
* dein.vimでプラグインを管理しているため、toml内でluaやvim scriptで設定を書く際にLSPを有効的に使いたいからです。
* 各言語のコードを別のファイルにした方が管理できている雰囲気が出て良いですよね？？


## Purpose

* dein.vimのように、tomlの中でluaやvim scriptを書く場合に役立ちます。
* 別のファイルにすることで、lspやハイライトや補完が機能することで、コードが書きやすくなります。
* Markdownの中でコードを書く際に、別ファイルになることで、コードブロックが書きやすくなります。


## Similar plugin

[thinca/vim-partedit](https://github.com/thinca/vim-partedit)

こちらのプラグインは選択範囲をスクラッチバッファで編集できるようにします。


## Install

dein.vimの場合

```toml
[[plugins]]
repo = 'yasunori-kirin0418/partial.vim'
on_cmd = [
  'PartialOpen',
  'PartialEdit',
  'PartialTabedit',
  'PartialVsplit',
  'PartialSplit',
  'PartialCreate',
  'PartialUpdate',
  'PartialSurround',
]
```

遅延起動させる場合、コマンドの実行をフックに読み込むことをお勧めします。


## Useage

```toml
[[plugins]]
repo = 'yasunori-kirin0418/partial.vim'
on_cmd = [
  'PartialOpen',
  'PartialEdit',
  'PartialTabedit',
  'PartialVsplit',
  'PartialSplit',
  'PartialCreate',
  'PartialUpdate',
  'PartialSurround',
]
hook_add = '''
" <% partial_path: ./partial/partial.vim

" e.g. some vimscript configurations...

" %>
'''
```

上記のように別言語で書かれたコードブロックがあります。

1. partial.vimは、この`<% ~ %>`で囲まれた範囲を別のファイルとして開きます。
1. 最初の行にコメントアウトで`<% partial_path: ./partial/partial.vim`と別ファイル(partial_file)へのパスを書く必要があります。
    この別ファイルへのパスは元のファイルからの相対パスか、絶対パスを指定してください。
1. 別ファイルにしたいコードの最終行にコメントアウトで`%>`を書く必要がります。
