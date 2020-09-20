# Some aliases

alias dk='docker'
alias op='openstack'
alias ks='kubectl'
alias py='python'



# Directory listing in a nice format

alias lla='ls -lAGh'
 
 
 
# Find zero size files
 
alias lsz='find . -type f -size 0 -exec ls {} \;'
 
 
 
# Remove all *.pyc files recursively
 
alias rmpyc='find . -name "*.pyc" -print0 | xargs -0 rm'
 
 
 
# Disk usage that also sorts the results by size and saves to a file
 
alias dus='du -Pscmx * | sort -nr | tee disk_usage.txt'
 
 
 
alias g='git'
 
alias gci='git commit -a'
 
alias gcia='git commit -a --amend'
 
alias gb='git branch'
 
alias gbd='git branch -D'
 
alias gco='git checkout'
 
alias gpu='git pull --rebase'
 
alias gg='git grep -i'
 
alias gs='git status'
 
alias gd='git diff'
 
alias gl='git log --oneline'
 
 
 
 
 
# Show all untracked files and directories in current dir
 
alias ng='git clean -n -d .'
 
 
 
# Fetch and track remote branch
 
function gfr
 
{
 
    git checkout --track -b $1 origin/$1
 
}
 
 
 
# Create remote git branch (and local too) from master
 
function gbr
 
{
 
    gco master
 
    gb $1
 
    g push -u origin $1
 
}