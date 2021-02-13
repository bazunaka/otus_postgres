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

