if [ $# -lt 2 ]; then
    echo "Usage: $0 <class> <cmd>"
    echo "Example: $0 my-class my-cmd"
    exit 1
fi
alacritty -o window.padding.x=20 -o window.padding.y=20 --class "$1" -e "$2" 
