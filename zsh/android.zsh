export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
function emulator { ( cd "$(dirname "$(whence -p emulator)")" && ./emulator "$@"; ) }
