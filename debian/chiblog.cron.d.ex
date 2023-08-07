#
# Regular cron jobs for the chiblog package.
#
0 4	* * *	root	[ -x /usr/bin/chiblog_maintenance ] && /usr/bin/chiblog_maintenance
