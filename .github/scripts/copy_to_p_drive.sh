

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

project_path=/media/github
timestamp=$(date "+%Y_%m_%d")
path=$project_path/$timestamp/$RUN_NUMBER/$tgt_dir

kinit svc-00773-006-github@ANALYTICAL-SOFTWARE.EU -kt /home/github/svc-00773-006-github.keytab

# this mount command is possible because
# 1. the user svc-00773-006-github is authorized via kerberos in the kinit step before
# 2. /etc/fsab contains an entry for a user mount in the /media/github directory that uses the cruid 1006 (i.e the id of the github user)
# 3. the s bit is set for the /sbin/mount.cifs executable (i.e. chmod +s /sbin/mount.cifs was run)
mount $project_path

mkdir -p $path

cp -r $src $path
