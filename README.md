# nvim

## get started
```sh
git clone https://github.com/strptrk/nvim-cfg.git ~/.config/nvim
nvim --headless "+Lazy! sync" +qa
```
## tree-sitter cli for certain parsers
```sh
cargo install tree-sitter-cli --git https://github.com/tree-sitter/tree-sitter.git
```

## language servers

### C/C++ (`clang` contains `clangd`)
```sh
sudo pacman -S clang
```

### lua
```sh
sudo pacman -S lua-language-server
```

### python
```sh
pip install "python-lsp-server[all]"
```

### go
```sh
sudo pacman -S gopls
```

### latex
```sh
sudo pacman -S texlab
# or
cargo install texlab
```

### CMake
```
pip install cmake-language-server
```

## debugger adapters
### python3
```sh
mkdir -p ~/.clones/virtualenvs
cd ~/.clones/virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy
```

### lldb-vscode
```sh
sudo pacman -S lldb
```

### vscode-lldb
```sh
# {aur helper} -S codelldb, such as
paru -S codelldb
```
OR
```sh
mkdir -p ~/.clones/vscode-lldb ~/.local/bin
cd ~/.clones/vscode-lldb
curl -LO $(curl -s https://api.github.com/repositories/49407251/releases | \
  jq '.[0].assets[] | select(.name == "codelldb-x86_64-linux.vsix").browser_download_url' -r)
unzip codelldb-x86_64-linux.vsix
ln -s $PWD/extension/adapter/codelldb ~/.local/bin
```

### cppdbg
```sh
mkdir -p ~/.clones/cpptools ~/.local/bin
cd ~/.clones/cpptools
curl -LO $(curl -s https://api.github.com/repos/microsoft/vscode-cpptools/releases | \
  jq -r '[.[].assets[] | select(.name == "cpptools-linux.vsix").browser_download_url][0]')
unzip cpptools-linux.vsix
chmod +x extension/debugAdapters/bin/OpenDebugAD7
ln -s $PWD/extension/debugAdapters/bin/OpenDebugAD7 ~/.local/bin
```
