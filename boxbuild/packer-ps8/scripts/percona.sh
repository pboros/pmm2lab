#!/bin/sh -eux

yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
percona-release setup ps80
yum install -y percona-server-server percona-toolkit percona-xtrabackup-80 MySQL-python pmm2-client 
