#/bin/bash
mount=(
/src/app-core/data
)
ip=$(ifconfig eth0 | awk -F'addr:|Bcast' '/Bcast/{print $2}')
if
        df >/dev/null 2>&1
then
        num=$(df -hT | grep glusterfs | wc -l)
        if [ $num -lt ${#mount[@]} ]
        then
                coment="**The current server IP address:${ip}\n\nThe following is a check GlusterFS mount system information:\n"
                for i in ${mount[@]}
                        do
                        if
                                grep $i /proc/mounts &>/dev/null
                        then
                                coment="${coment}${i} is mounted.\n"
                        else
                                coment="${coment}${i} is not mounted.\n"
                                umount $i &>/dev/null
                        fi
                        done
                        coment="${coment}\nThe following is the output of the <df -hT>command:\n$(df -hT -t fuse.glusterfs 2>/dev/null)\n"
                        df=$(mount -a &>/dev/null;df -hT -t fuse.glusterfs 2>/dev/null)
                        coment="${coment}\nThe following content is performed after the <mount -a> command:\n${df}"
        fi
else
        coment="**The current server IP address:${ip}\n\nThe following is a check GlusterFS mount system information:\n"
        for i in ${mount[@]}
                do
                coment="${coment}${i} is not mounted.\n"
                umount $i &>/dev/null
                done
        coment="${coment}\nThe following is the output of the <df -hT>command:\n$(df -hT -t fuse.glusterfs 2>/dev/null)\n"
        df=$(mount -a &>/dev/null;df -hT -t fuse.glusterfs 2>/dev/null)
        coment="${coment}\nThe following content is performed after the <mount -a> command:\n${df}"
fi
if [ ! -z "$coment" ]
        then
                echo -e "$coment" | mail -s "$ip  GlusterFS mount is missing" -c "xin.huang@saninco.com peiwei.xiang@xinketechnology.com" jeff.yang@saninco.com
fi


