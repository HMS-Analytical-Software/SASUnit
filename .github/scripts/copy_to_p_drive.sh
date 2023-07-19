

if [ $# -lt 2 ]; then
    echo "usage: $0 <src> <tgt_dir>"
    exit 1
fi

if [ -z "${RUN_NUMBER}" ]; then
    echo "RUN_NUMBER must be set in env"
    exit 2
fi

src=$1
tgt_dir=$2

p_drive=/mnt/hms/laufwerke/p/hms_interne_projekte/00773_kompetenzfelder/00773-006_SAS/SASUnit/github
timestamp=$(date "+%Y_%m_%d")
path=$p_drive/$timestamp/$RUN_NUMBER/$tgt_dir

# kinit svc-00773-006-github@ANALYTICAL-SOFTWARE.EU -k -t /home/github/svc-00773-006-github.keytab

kinit samuel.melm@ANALYTICAL-SOFTWARE.EU -k -t /home/github/sme.keytab


mkdir -p $path

cp -r $src $path
