#centOS 7 - 3 virtual mashines

#install postgresql
sudo yum install https://apt.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum install -y repmgr12 postgresql12 postgresql12-server postgresql12-contrib postgresql12-libs

#add to PATH
cat >> /var/lib/pgsql/.bash_profile << 'EOF'
    PATH=$PATH:$HOME/bin:/usr/pgsql-12/bin
    export PATH
EOF

#add to autoloading
systemctl enable repmgr12 postgresql-12

#initialization of database
/usr/pgsql-12/bin/postgresql-12-setup initdb

#edit config files
nano /var/lib/pgsql/12/data/postgresql.conf -> LISTEN_ADDRESS = '*'
cat > /var/lib/pgsql/12/data/repmgr.conf << EOF
    shared_preload_libraries = 'repmgr'
    max_wal_senders = 10
    max_replication_slots = 15
    wal_level = 'replica'
    hot_standby = on
    archive_mode = on
    archive_command = '/bin/true'
EOF

#add to main config
echo -e "include_if_exists 'repmgr.conf'" >> /var/lib/pgsql/12/data/postgresql.conf

#edit pg_hba.conf
nano /var/lib/pgsql/12/data/pg_hba.conf
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
host    study_db        study           192.168.1.0/24          md5
# IPv6 local connections:
host    all             all             ::1/128                 ident
# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     trust
host    replication     all             127.0.0.1/32            trust
host    replication     all             192.168.1.0/24          trust

#edit owner for conf files
chown postgres:postgres /var/lib/pgsql/12/data/{pg_hba.conf,repmgr.conf}
chmod 600 /var/lib/pgsql/12/data/{pg_hba.conf,repmgr.conf}

#create user and database repmgr
createuser -s repmgr
createdb repmgr -O repmgr
alter user repmgr set search_path to repmgr, "$user", public;