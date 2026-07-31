settings {
    pidfile    = "/data/logs/lsyncd/var/run/lsyncd.pid",
	statusFile = "/data/logs/lsyncd/var/run/lsyncd.status",
	logfile    = "/data/logs/lsyncd/lsyncd.log",	
	nodaemon   = true,
}

sync {
	default.rsync,
	source    = "/data/www/storage",
	target    = "tomoko@192.168.1.118::storage",
	delay     = 2,
	rsync     = {
		binary   = "/usr/local/rsync/bin/rsync",
		archive         = true,
		compress        = true,
		verbose         = true,
		password_file   = "/data/logs/lsyncd/rsync.pass"
	}
}
