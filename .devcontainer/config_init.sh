#!/bin/bash

## Make sure dependencies and types are installed
deno task install

##
## Configure the local container environment
##

## We need to add a .env if it doesn't exist already
if [ ! -f .devcontainer/.env ]; then
    cp .devcontainer/.env.dist .devcontainer/.env
fi

## We can add ZSH as our default shell if present
if [ -f /bin/zsh ]; then
    usermod -s /bin/zsh ${USER}
fi

## Append content to .bashrc using a here-document
cat << 'EOF' > ${HOME}/.bashrc

################################################################################

## Function to parse the current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

## Custom PS1 with Git branch
export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "

## Useful shortcut aliases
alias d='docker'
alias dc='docker-compose'
alias p='python'
alias pr='poetry run'
alias ll='ls -larth --color'

## Git aliases
## Taken from oh-my-zsh's git plugin and translated to bash
##     https://github.com/robbyrussell/oh-my-zsh/wiki/Cheatsheet#helpful-aliases-for-common-git-tasks
##     https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/git/git.plugin.zsh
function git_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}
function git_current_repository() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}
alias g="git"
alias gst="git status"
alias gl="git pull"
alias gup="git pull --rebase"
alias gp="git push"
alias gd="git diff"
alias gdc="git diff --cached"
function gdv() { # mine doesn't add -w
  git diff $@ | vim -R -
}
function gdcv() { # my own
  git diff --cached $@ | vim -R -
}
alias gc="git commit -v"
alias gc!="git commit -v --amend"
alias gca="git commit -v -a"
alias gca!="git commit -v -a --amend"
alias gcmsg="git commit -m"
alias gco="git checkout"
alias gcm="git checkout master"
alias gr="git remote"
alias grv="git remote -v"
alias grmv="git remote rename"
alias grrm="git remote remove"
alias gsetr="git remote set-url"
alias grup="git remote update"
alias grbi="git rebase -i"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias gb="git branch"
alias gba="git branch -a"
alias gcount="git shortlog -sn"
alias gcl="git config --list"
alias gcp="git cherry-pick"
alias glg="git log --stat --max-count=10"
alias glgg="git log --graph --max-count=10"
alias glgga="git log --graph --decorate --all"
alias glo="git log --oneline --decorate --color"
alias glog="git log --oneline --decorate --color --graph"
alias gss="git status -s"
alias ga="git add"
alias gm="git merge"
alias grh="git reset HEAD"
alias grhh="git reset HEAD --hard"
alias gclean="git reset --hard && git clean -dfx"
alias gwc="git whatchanged -p --abbrev-commit --pretty=medium"
alias gsts="git stash show --text"
alias gsta="git stash"
alias gstp="git stash pop"
alias gstd="git stash drop"
function ggpull {
  git pull origin $(git_current_branch)
}
function ggpur {
  git pull --rebase origin $(git_current_branch)
}
function ggpush {
  git push origin $(git_current_branch)
}
function ggpnp {
  git pull origin $(git_current_branch) && git push origin $(git_current_branch)
}
function glp(){
  git log --pretty=$@
}

EOF
