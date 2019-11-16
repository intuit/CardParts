if which jazzy >/dev/null; then
  cd .. && jazzy
else
  echo "warning: jazzy not installed, run: `gem install jazzy`"
fi