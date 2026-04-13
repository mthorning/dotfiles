# Personal machine PATH additions needed in non-interactive zsh too.

[[ -f "$HOME/.config/zsh/zshenv" ]] && source "$HOME/.config/zsh/zshenv"

export ANDROID_AVD_HOME="$HOME/.android/avd"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

path=(
  "$HOME/flutter/flutter/bin"
  "$HOME/.pub-cache/bin"
  "$ANDROID_SDK_ROOT/build-tools/35.0.0"
  "$ANDROID_HOME/emulator"
  "$ANDROID_HOME/cmdline-tools"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
  "$ANDROID_HOME/platform-tools"
  "/opt/homebrew/opt/openjdk/bin"
  $path
)
export PATH
