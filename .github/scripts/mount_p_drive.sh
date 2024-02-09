kinit svc-00773-006-github@ANALYTICAL-SOFTWARE.EU -kt /home/github/svc-00773-006-github.keytab

if grep -qs $p_drive /proc/mounts > /dev/null; then
    echo "$p_drive is already mounted"
else
    # this mount command is possible because
    # 1. the user svc-00773-006-github is authorized via kerberos in the kinit step before
    # 2. /etc/fsab contains an entry for a user mount in the /media/github directory that uses the cruid 1006 (i.e the id of the github user)
    # 3. the s bit is set for the /sbin/mount.cifs executable (i.e. chmod +s /sbin/mount.cifs was run)
    mount $p_drive
fi
