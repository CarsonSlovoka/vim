# vimrc

如果你的工作環境不適合裝nvim, 只需要很簡潔的配置, 可以抓取[.vimrc](.vimrc)

只有一個檔案，丟給~/.vimrc即可使用


```sh
ln -siv $(realpath vimrc) ~/.vimrc

# 或者抓整個目錄也行
git clone https://github.com/CarsonSlovoka/vim ~/.vim
```

--

vim的配置

```
~/.vim/
├── pack/
│   └── myplugins/                   # 你可以取任何名字
│       ├── start/                   # 啟動時自動載入的插件
│       │   └── myplugin/
│       │       ├── plugin/          # 定義命令、映射、自動命令
│       │       ├── autoload/        # 延遲載入（推薦）
│       │       ├── syntax/          # 語法檔案
│       │       ├── ftplugin/        # 檔案類型專用設定
│       │       ├── after/           # 覆蓋其他插件
│       │       └── doc/             # 幫助文件
│       │          ├── tags
│       │          └── myplugin.txt
│       └── opt/                     # 需要 :packadd 才載入的插件
└── vimrc                            # 名稱不是 .vimrc
```

預設的啟動會去抓

1. ~/.vimrc
2. ~/.vim/vimrc
