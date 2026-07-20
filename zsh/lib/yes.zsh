
check_yes () {
  while true; do
    printf "Do you want to continue? (y/n): "
    read yn
    if [[ "$yn" == "y" || "$yn" == "Y" ]]; then
      return 0
    elif [[ "$yn" == "n" || "$yn" == "N" ]]; then
      return 1
    else
      echo "Please answer y or n."
    fi
  done
}
