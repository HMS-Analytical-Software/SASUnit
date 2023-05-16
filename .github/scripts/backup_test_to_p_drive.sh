
echo $#

if [ $# -lt 2 ]; then
    echo "usage: $0 <run number> <language>"
fi

run_num=$1
language=$2
target_name=${3:-linux_$language}

P_DRIVE=/mnt/hms/laufwerke/p/hms_interne_projekte/00773_kompetenzfelder/00773-006_SAS/SASUnit/github
timestamp=$(date "+%Y_%m_%d")
keytab_file=/home/github/samuel.melm.keytab
path=$P_DRIVE/$timestamp/$run_num/$target_name

kinit samuel.melm@ANALYTICAL-SOFTWARE.EU -k -t $keytab_file

mkdir -p $path
mkdir -p $path/example

cp -r $language/doc $path
cp -r $language/log $path
cp -r example/$language/doc $path/example/doc
