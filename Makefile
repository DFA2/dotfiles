DOTFILES := $(shell find $(SOURCEDIR) -type f -name '.*')
ERLANG_VERSION = 22.3
ELIXIR_VERSION = v1.10.2
PHOENIX_VERSION = 1.4.14

all: install

.PHONY: deps
deps:
	sudo apt-get -y install zsh procps curl gcc build-essential	\
			        automake autoconf libncurses5-dev								\
			        libssl-dev flex xsltproc												\
			        libwxgtk3.0-gtk3-dev														\
			        libwxgtk3.0-gtk3-0v5 tmux												\
			        inotify-tools tig okular cargo									\
							xss-lock


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


# fuck me, this is why no one likes the BEAM.
# compare this to go get .../gopls@latest... ;_; <3 beam

.PHONY: install
install: ohmyzsh link

