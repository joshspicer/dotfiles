# Source shared alias
. ~/.common

export OSH=$HOME/.oh-my-bash

THEME_DIR="$OSH/custom/themes/josh"
THEME_NAME="josh"
THEME_FILE="$THEME_NAME.theme.sh"
if [ ! -z $CODESPACES ] && [ ! -f $THEME_DIR/$THEME_FILE ];then
    mkdir -p $THEME_DIR
    ln -sf /home/codespace/dotfiles/$THEME_FILE $THEME_DIR/$THEME_FILE
else
    THEME_NAME="garo"
fi

export OSH=$HOME/.oh-my-bash
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="$THEME_NAME"
source $OSH/oh-my-bash.sh
