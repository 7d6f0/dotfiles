XDG_CONFIG_HOME=$(HOME)/.config
XDG_DATA_HOME=$(HOME)/.local/share

init: makedir alacritty vim tmux zsh fzf asdf bin

makedir:
	mkdir -p $(HOME)/.config
	mkdir -p $(HOME)/.local/bin
	mkdir -p $(XDG_CONFIG_HOME)/alacritty

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
	cd $(XDG_DATA_HOME)/zsh-syntax-highlighting && git pull
endif

fzf:
	@echo "### fzf ###"
ifeq ($(wildcard $(XDG_CONFIG_HOME)/fzf),)
	git clone --depth 1 https://github.com/junegunn/fzf.git $(XDG_CONFIG_HOME)/fzf
else
	cd $(XDG_CONFIG_HOME)/fzf && git pull
endif
	$(XDG_CONFIG_HOME)/fzf/install --all --xdg --no-update-rc --no-bash --no-fish
	rsync -a $(XDG_CONFIG_HOME)/fzf/bin/* $(HOME)/.local/bin/

asdf:
	@echo "### asdf ###"
	ln -snf $(PWD)/.tool-versions $(HOME)/
ifeq ($(wildcard $(XDG_DATA_HOME)/asdf),)
	git clone https://github.com/asdf-vm/asdf.git $(XDG_DATA_HOME)/asdf
else
	cd $(XDG_DATA_HOME)/asdf && git pull
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
	curl -fLO  https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64
	curl -fLO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-apple-darwin.tar.gz
	curl -fLO https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-v0.23.0-x86_64-apple-darwin.tar.gz
	curl -fLO https://github.com/x-motemen/ghq/releases/download/v1.4.2/ghq_darwin_arm64.zip
endif
ifeq ($(shell uname), Linux)
	curl -fLO "https://dl.k8s.io/release/$$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	curl -fLO https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
	curl -fLO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
	curl -fLO https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-v0.23.0-aarch64-unknown-linux-gnu.tar.gz
	curl -fLO https://github.com/x-motemen/ghq/releases/download/v1.4.2/ghq_linux_amd64.zip
endif
ifeq ($(wildcard kubectl),)
	chmod +x $(PWD)/kubectl
	rsync -a kubectl $(HOME)/.local/bin
	rm -f kubectl
endif
ifeq ($(wildcard jq),)
	chmod +x $(PWD)/jq*
	rsync -a jq* $(HOME)/.local/bin
	rm -f jq*
endif
ifeq ($(wildcard ripgrep),)
	tar xvzf $$(ls ripgrep*.tar.gz)
	rsync -a ripgrep*/rg $(HOME)/.local/bin
	rm -rf ripgrep*
endif
ifeq ($(wildcard bat),)
	tar xvzf $$(ls bat*.tar.gz)
	rsync -a bat*/bat $(HOME)/.local/bin
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
	rm -rf $(XDG_CONFIG_HOME)/fzf $(HOME)/.local/bin/fzf*
	rm -rf $(HOME)/.tool-versions $(XDG_DATA_HOME)/asdf
	rm -f $(HOME)/.local/bin/{kubectl,jq,rg,bat,ghq}
