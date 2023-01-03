# partial.vim

このプラグインはコード内の別言語のコードを別ファイル(partial_file)にコピーして、分けた別ファイル(partial_file)で編集して同期できるようにします。

::NOTE::INFO:: このプラグインはテキストウェアです。機能の実装はされていません。


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
on_cmd = ['PartialOpen', 'PartialVsplit', 'PartialSplit', 'PartialTabedit', 'PartialSync']
```

遅延起動させる場合、コマンドの実行をフックに読み込むことをお勧めします。


## Useage

```toml
[[plugins]]
repo = 'yasunori-kirin0418/partial.vim'
on_cmd = ['PartialOpen', 'PartialVsplit', 'PartialSplit', 'PartialTabedit', 'PartialSync']
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


## ToDo

- [ ] `<% %>`の囲みをパースできるようにする。[perse]
    - [ ] `partial_path`で指定した、既に存在する別ファイルを開けるようにする。
    - [ ] `partial_path`で指定した、存在しない別ファイルを新規作成できるようにする。
    - [ ] `<% %>`で囲まれた範囲のコードを別ファイルにして保存する。
- [ ] コマンドを作成して、各種の開き方ができるようにする。[command open]
    - [ ] 通常の開く(edit)
    - [ ] 縦分割で開く(vsplit)
    - [ ] 横分割で開く(split)
    - [ ] タブで開く(tabedit)
- [ ] 元ファイルと別ファイルの反映を同期する。[sync]
    - [ ] コマンドで別ファイルを開いて編集→保存したら、元のファイルでも変更が反映されるようにする。
    - [ ] 元ファイルだけを編集したあとに、別ファイルにも変更が反映されるようにする。
    - [ ] 別ファイルだけを編集したあとに、元ファイルにも変更が反映されるようにする。
        - [ ] 反映時に、元ファイルとの差分が見れるようにする。
        - [ ] 初期状態ではタイムスタンプで更新を自動化する。
        - [ ] 反映時に、どちらの変更を使うか選択できるようにする。
- [ ] オプションを作成する。なにかしらの設定ができるようにする。(重要)[option]
