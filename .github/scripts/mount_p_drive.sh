kinit svc-00773-006-github@ANALYTICAL-SOFTWARE.EU -kt /home/github/svc-00773-006-github.keytab

if grep -qs $project_path /proc/mounts; then
    echo "$project_path is already mounted"
else
    # this mount command is possible because
    # 1. the user svc-00773-006-github is authorized via kerberos in the kinit step before
    # 2. /etc/fsab contains an entry for a user mount in the /media/github directory that uses the cruid 1006 (i.e the id of the github user)
    # 3. the s bit is set for the /sbin/mount.cifs executable (i.e. chmod +s /sbin/mount.cifs was run)
    mount $project_path
fi
