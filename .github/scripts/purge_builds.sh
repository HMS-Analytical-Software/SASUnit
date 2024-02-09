if [ $# -lt 1 ]; then
    echo "usage: $0 <directory_path>"
    exit 1
fi
exit

echo ""
echo "----------------------------------------------"

p_drive=$1
echo "--- p_drive:" $p_drive

echo "Checking files"
files=$(find -P $p_drive/ -maxdepth 2 -mindepth 2 -type d)
filecount=$(echo "$files" | wc -l)
((filescount2del=$filecount - ${{ env.RUNS_TO_KEEP }}))

if [ $filescount2del -le 0 ]; then
  echo "Nothing to do"
  exit 0
fi

files2del=$(echo "$files" | sort | head -n $filescount2del)

echo "found $filecount will delete $filescount2del"
echo "deleting the following runs"
echo "$files2del"

echo "$files2del" | xargs -I {} bash -c "echo rm {}; rm -r {}"