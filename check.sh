#!/bin bash
source /prodcheck/function.sh
source /prodcheck/environment-ip.sh

REPORT=report_$(date +"%Y%m%d%H%M%S")
touch /prodcheck/$REPORT

echo-status log-check-ha $HA1_IP "HA1" $REPORT
echo-status log-check-ha $HA2_IP "HA2" $REPORT
echo-status log-check-nginx $APP1_IP "APP1" $REPORT
echo-status log-check-nginx $APP2_IP "APP2" $REPORT