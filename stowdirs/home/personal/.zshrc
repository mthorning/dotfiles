
source ~/dotfiles/.zshrc

# Flutter development
export PATH=$HOME/flutter/flutter/bin:$PATH
export ANDROID_AVD_HOME=$HOME/.android/avd
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$HOME/.pub-cache/bin:$ANDROID_SDK_ROOT/build-tools/35.0.0:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
