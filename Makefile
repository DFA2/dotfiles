DOTFILES := $(shell find $(SOURCEDIR) -type f -name '.*')
ERLANG_VERSION = 22.2.7
ELIXIR_VERSION = v1.10.1
PHOENIX_VERSION = 1.4.14

all: install

.PHONY: deps
deps:
	sudo apt-get -y install zsh procps curl gcc build-essential	\
			        automake autoconf libncurses5-dev	\
			        libssl-dev flex xsltproc		\
			        libwxgtk3.0-gtk3-dev			\
			        libwxgtk3.0-gtk3-0v5 tmux		\
			        inotify-tools tig okular

.PHONY: ohmyzsh
ohmyzsh:
	@sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

.PHONY: emacs-early-init
emacs-early-init:
	-@mkdir ~/.emacs.d
	@echo ";; Let package+ deal with package initialization \
rather than emacs itself" >> ~/.emacs.d/early-init.el
	@echo "(setq package-enable-at-startup nil)" >> ~/.emacs.d/early-init.el

.PHONY: link
link:
	@for dotfile in $(DOTFILES); do \
		ln -sr $$dotfile ~/$$dotfile; \
	done

.PHONY: asdf
asdf:
	@git clone https://github.com/asdf-vm/asdf.git ~/.asdf
	@cd ~/.asdf && git checkout `git describe --abbrev=0 --tags`
	@asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
	@asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

.PHONY: erlang
erlang:
	asdf install erlang "$(ERLANG_VERSION)"
	asdf global erlang "$(ERLANG_VERSION)"

.PHONY: elixir
elixir:
	asdf install elixir "$(ELIXIR_VERSION)"
	asdf global elixir "$(ELIXIR_VERSION)"

.PHONY: phx
phx:
	mix local.hex --force
	mix archive.install --force hex phx_new 1.4.14

.PHONY: gotools
gotools:
	-@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b `go env GOPATH`/bin v1.24.0
	@go get golang.org/x/tools/gopls@latest
	@go get -u github.com/haya14busa/gopkgs/cmd/gopkgs
	@go get github.com/fatih/gomodifytags
	@go get golang.org/x/tools/cmd/guru

.PHONY: install
install: ohmyzsh link asdf erlang elixir phx gotools




