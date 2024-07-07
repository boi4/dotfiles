#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/boi4/dotfiles"
repo_dir="$HOME/.cfg"
BACKUP_DIR="$HOME/.dotfiles_backup"
DOTF_CMD="git --git-dir=$repo_dir --work-tree=$HOME"

# Clone the repository as a bare repository
function clone_repo() {
    TMPDIR=/tmp/$RANDOM
    echo "Cloning the repository..."
    git clone --no-checkout "$REPO_URL" --separate-git-dir="$repo_dir" $TMPDIR
    rm -r $TMPDIR
    # Unstage all
    $DOTF_CMD restore --staged "$HOME"
}

# Generate an incremental backup filename
function increment_backup_filename() {
    local file=$1
    local i=1
    local backup_file="$BACKUP_DIR/$file"

    while [ -e "$backup_file.$i" ]; do
        ((i++))
    done

    echo "$backup_file.$i"
}

# Backup conflicting files
function backup_file() {
    local file=$1
    local backup_file=$(increment_backup_filename "$file")
    echo "Backing up $file to $backup_file"
    mkdir -p "$(dirname "$backup_file")"
    mv "$file" "$backup_file"
}

# Handle files during the checkout process
function process_files() {
    local conflicts=($($DOTF_CMD ls-tree -r --name-only HEAD))
    local replace_all=false
    local skip_all=false

    for file in "${conflicts[@]}"; do
        while [ -f "$HOME/$file" ]; do
            if $replace_all; then
                backup_file "$file"
                $DOTF_CMD checkout -- "$file"
                break
            elif $skip_all; then
                echo "Skipping $file..."
                break
            fi

            echo "$file exists."
            echo "What would you like to do?"
            echo "[d]iff, [r]eplace, [s]kip, [R]eplace All, [S]kip All"
            read -r action

            case $action in
                d)
                    diff --color "$HOME/$file" <($DOTF_CMD show "HEAD:$file")
                ;;
                r)
                    backup_file "$file"
                    $DOTF_CMD checkout -- "$file"
                    break
                ;;
                s)
                    echo "Skipping $file..."
                    break
                ;;
                R)
                    replace_all=true
                    backup_file "$file"
                    $DOTF_CMD checkout -- "$file"
                    break
                ;;
                S)
                    skip_all=true
                    echo "Skipping $file..."
                    break
                ;;
                *)
                    echo "Invalid option. Please choose again."
                ;;
            esac
        done

        if [ ! -f "$HOME/$file" ]; then
            $DOTF_CMD checkout -- "$file"
        fi
    done
}

# Check out the files
function checkout_files() {
    echo "Checking out the files..."
    mkdir -p "$BACKUP_DIR"
    process_files
}

# Clone miscellaneous repositories
function clone_misc() {
    local repo_url=$1
    local dest_dir=$2
    
    if [ ! -d "$dest_dir" ] || [ -z "$(ls -A "$dest_dir")" ]; then
        echo "Cloning $repo_url into $dest_dir..."
        mkdir -p "$dest_dir"
        git clone "$repo_url" "$dest_dir"
    else
        echo "$dest_dir already exists and is not empty."
    fi
}

# Main function
function main() {
    if [ ! -d "$repo_dir" ]; then
        clone_repo
        checkout_files
    else
        echo "$repo_dir already exists. Please remove it if you want to re-initialize."
    fi

    # Setup ranger
    mkdir -p "$HOME/.config/ranger/plugins/"
    clone_misc "https://github.com/SL-RU/ranger_udisk_menu" "$HOME/.config/ranger/plugins/ranger_udisk_menu"
    clone_misc "https://github.com/cdump/ranger-devicons2" "$HOME/.config/ranger/plugins/ranger-devicons2"
    clone_misc "https://github.com/maximtrp/ranger-archives.git" "$HOME/.config/ranger/plugins/ranger-archives"
    ln -sfv "ranger-archives/compress.py" "$HOME/.config/ranger/"
    ln -sfv "ranger-archives/extract.py" "$HOME/.config/ranger/"
    touch "$HOME/.config/ranger/__init__.py"
    
    
    echo ""
    echo "Please update your shell to zsh and add the following to your .zshrc:"
    echo "alias dotf='git --git-dir=$repo_dir --work-tree=$HOME'"
    echo "if type compdef &>/dev/null; then compdef dotf='git'; fi"
}

main
