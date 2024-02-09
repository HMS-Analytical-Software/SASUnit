if [ $# -lt 2 ]; then
    echo "usage: $0 <directory_path> <RUNS_TO_KEEP>"
    exit 1
fi

echo ""
echo "----------------------------------------------"

p_drive=$1
runs2keep=$2
echo "--- p_drive:" $p_drive
echo "--- RUNS_TO_KEEP:" $runs2keep

echo "Checking files"
files=$(find -P $p_drive/ -maxdepth 2 -mindepth 2 -type d)
filecount=$(echo "$files" | wc -l)
((filescount2del=$filecount - $runs2keep))

if [ $filescount2del -le 0 ]; then
  echo "Nothing to do"
  exit 0
fi

files2del=$(echo "$files" | sort | head -n $filescount2del)

echo "found $filecount will delete $filescount2del"
echo "deleting the following runs"
echo "$files2del"

echo "$files2del" | xargs -I {} bash -c "echo rm {}; rm -r {}"