#!/bin/bash
#backup all of core 
function log-check-ha
{
     scp root@$1:/var/log/haproxy.log /tmp/$2.log
    if [ -s /tmp/$2.log ]
    then

        echo "==============$2 log=================" >> /prodcheck/$3
        cat /tmp/$2.log >> /prodcheck/$3
        return 1
    else
        return 0
    fi
}
############################################################################################################################
function log-check-nginx
{
    scp root@$1:/var/log/nginx/error.log /tmp/$2.log
    TODAY=date -d today +"%Y/%m/%d"
    if [ -s /tmp/$2.log ]
    then

        echo "==============$2 log=================" >> /prodcheck/$3
        cat /tmp/$2.log | grep ${TODAY} >> /prodcheck/$3
        return 1
    else
        return 0
    fi
}
############################################################################################################################

function log-check-pg
{
    scp root@$1:/var/log/postgresql/postgresql-9.6-main.log /tmp/$2.log
    TODAY=date -d today +"%Y/%m/%d"
    if [ -s /tmp/$2.log ]
    then

        echo "==============$2 log=================" >> /prodcheck/$3
        cat /tmp/$2.log | grep ${TODAY} >> /prodcheck/$3
        return 1
    else
        return 0
    fi
}

############################################################################################################################
#Output running state
function echo-status
	{	
		echo "=====================$1 start $(date +%T)===================="
		#log-check-ha $HA1_IP "HA1" $REPORT
		$1 $2 $3 $4
		is=$?
		if [ $is -eq 0 ]
			then
				echo "$3 log is clean"
		elif [ $is -eq 10 ];then
			echo ""
		else 
			echo "$3 has log record"

		fi
		echo "=====================$1 end $(date +%T)===================="



	}
