#!/bin/bash

RUBY_VERSION=2.2.0

echo "Installing CI environment for $(whoami). Requires git"
cd ~

type git >/dev/null 2>&1 || { echo >&2 "I require git but it's not installed.  Aborting."; exit 1; }

# rbenv
if [ -d ~/.rbenv ]; then
  echo "rbenv already installed. skipping"
else
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
fi

# ruby-build
if [ -d ~/.rbenv/plugins/ruby-build ]; then
  echo "ruby_build already installed. skipping"
else
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

source ~/.bash_profile

# Installing ruby dependencies
cd /tmp
rbenv rehash
rbenv install $RUBY_VERSION # rbenv install -l
rbenv rehash
rbenv local $RUBY_VERSION

# Installing test kitchen
mkdir -p ~/code/ruby/cookbooks && cd $_ && git init . && gem install test-kitchen

echo "I've dumped the rbenv configuration to ~/.bash_profile, move it to ~/.zshrc if zsh or ~/.bashrc if ubuntu and correctly source.";
