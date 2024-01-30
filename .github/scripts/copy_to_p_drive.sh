

if [ $# -lt 2 ]; then
    echo "usage: $0 <src> <tgt_dir>"
    exit 1
fi

if [ -z "${RUN_NUMBER}" ]; then
    echo "RUN_NUMBER must be set in env"
    exit 2
fi

SCRIPT_DIR=$(dirname $0) # the directory of this script

src=$1
tgt_dir=$2

project_path=/media/github
timestamp=$(date "+%Y_%m_%d")
path=$project_path/$timestamp/$RUN_NUMBER/$tgt_dir

./SCRIPT_DIR/mount_p_drive.sh

mkdir -p $path

cp -r $src $path
