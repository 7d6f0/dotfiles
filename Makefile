BIN_DIR=$(HOME)/.local/bin
XDG_CONFIG_HOME=$(HOME)/.config
XDG_DATA_HOME=$(HOME)/.local/share

init: makedir alacritty vim tmux zsh fzf asdf bin

makedir:
	mkdir -p $(BIN_DIR)
	mkdir -p $(XDG_CONFIG_HOME)/alacritty
	mkdir -p $(XDG_DATA_HOME)

alacritty:
	@echo "### alacritty ###"
	ln -snf $(PWD)/alacritty.yml $(XDG_CONFIG_HOME)/alacritty/
	curl -fLo $(XDG_CONFIG_HOME)/alacritty/tokyo-night.yaml https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/tokyo-night.yaml

vim:
	@echo "### vim ###"
	ln -snf $(PWD)/.vimrc $(HOME)/
	curl -fLo $(HOME)/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qal

tmux:
	@echo "### tmux ###"
	ln -snf $(PWD)/.tmux.conf $(HOME)/

zsh:
	@echo "### zsh ###"
	ln -snf $(PWD)/.zshrc $(HOME)/
	ln -snf $(PWD)/.zsh_prompt $(HOME)/
ifeq ($(wildcard $(XDG_DATA_HOME)/zsh-syntax-highlighting),)
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(XDG_DATA_HOME)/zsh-syntax-highlighting
else
	(cd $(XDG_DATA_HOME)/zsh-syntax-highlighting && git pull)
endif

fzf:
	@echo "### fzf ###"
ifeq ($(wildcard $(XDG_CONFIG_HOME)/fzf),)
	git clone --depth 1 https://github.com/junegunn/fzf.git $(XDG_CONFIG_HOME)/fzf
else
	(cd $(XDG_CONFIG_HOME)/fzf && git pull)
endif
	$(XDG_CONFIG_HOME)/fzf/install --all --xdg --no-update-rc --no-bash --no-fish
	rsync -a $(XDG_CONFIG_HOME)/fzf/bin/* $(BIN_DIR)

asdf:
	@echo "### asdf ###"
	ln -snf $(PWD)/.tool-versions $(HOME)/
ifeq ($(wildcard $(XDG_DATA_HOME)/asdf),)
	git clone https://github.com/asdf-vm/asdf.git $(XDG_DATA_HOME)/asdf
else
	(cd $(XDG_DATA_HOME)/asdf && git pull)
endif
	@source $(XDG_DATA_HOME)/asdf/asdf.sh && asdf plugin add golang || true
	@source $(XDG_DATA_HOME)/asdf/asdf.sh && asdf plugin add python || true
	@source $(XDG_DATA_HOME)/asdf/asdf.sh && asdf plugin add rust || true
	@source $(XDG_DATA_HOME)/asdf/asdf.sh && asdf plugin add nodejs || true
	asdf install

bin:
	@echo "### bin ###"
ifeq ($(shell uname), Darwin)
	curl -fLO "https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
	curl -s https://api.github.com/repos/stedolan/jq/releases/latest | grep "browser_download_url.*osx" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
	curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep "browser_download_url.*darwin" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
	curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep "browser_download_url.*darwin" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
	curl -s https://api.github.com/repos/x-motemen/ghq/releases/latest | grep "browser_download_url.*darwin_arm" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
endif
ifeq ($(shell uname), Linux)
	curl -fLO "https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	curl -s https://api.github.com/repos/stedolan/jq/releases/latest | grep "browser_download_url.*linux64" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
	curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep "browser_download_url.*linux-musl" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
	curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep "browser_download_url.*linux-gnu" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
	curl -s https://api.github.com/repos/x-motemen/ghq/releases/latest | grep "browser_download_url.*linux_amd64" | cut -d : -f 2,3 | tr -d \" | xargs -n1 curl -fLO
endif
ifeq ($(wildcard kubectl),)
	chmod +x $(PWD)/kubectl
	rsync -a kubectl $(BIN_DIR)
	rm -f kubectl
endif
ifeq ($(wildcard jq),)
	chmod +x $(PWD)/jq*
	rsync -a jq* $(BIN_DIR)/jq
	rm -f jq*
endif
ifeq ($(wildcard ripgrep),)
	tar xvzf $$(ls ripgrep*.tar.gz)
	rsync -a ripgrep*/rg $(BIN_DIR)
	rm -rf ripgrep*
endif
ifeq ($(wildcard bat),)
	tar xvzf $$(ls bat*.tar.gz)
	rsync -a bat*/bat $(BIN_DIR)
	rm -rf bat*
endif
ifeq ($(wildcard ghq),)
	unzip $$(ls ghq*.zip)
	rsync -a ghq*/ghq $(HOME)/.local/bin
	rm -rf ghq*
endif

clean:
	rm -rf $(XDG_CONFIG_HOME)/alacritty
	rm -f $(HOME)/.vimrc $(HOME)/.vim/autoload/plug.vim
	rm -f $(HOME)/.tmux.conf
	rm -f $(HOME)/{.zshrc,.zsh_prompt} $(XDG_DATA_CONFIG_HOME)/zsh-syntax-highlighting
	rm -rf $(XDG_CONFIG_HOME)/fzf $(BIN_DIR)/fzf*
	rm -rf $(HOME)/.tool-versions $(XDG_DATA_HOME)/asdf
	rm -f $(BIN_DIR)/{kubectl,jq,rg,bat,ghq}
