# Source shared alias
. ~/.common

export OSH=$HOME/.oh-my-bash

if [ ! -z $CODESPACES ]; then
    ## Local Case (not in Codespaces)

    THEME_DIR="$OSH/custom/themes/josh"
    THEME_NAME="garo"
    
    export OSH=$HOME/.oh-my-bash
    # Set name of the theme to load. Optionally, if you set this to "random"
    # it'll load a random theme each time that oh-my-bash is loaded.
    OSH_THEME="$THEME_NAME"
    source $OSH/oh-my-bash.sh
else
    ## Codespaces Case
    
    # Should source /etc/bash.bashrc to get image-specific commands
fi
