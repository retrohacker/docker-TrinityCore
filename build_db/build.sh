#!/usr/bin/env bash
print_status () {
  printf "\n### $1\n\n"
}

bullet_list () {
  printf "*  $1\n"
}

print_status "Uploading database scheme..."
cat /sql/create/create_mysql.sql | mysql -hmysql -P3306 -uroot -pfuckitshipit

print_status "Creating auth tables..."
cat /sql/base/auth_database.sql | mysql -hmysql -P3306 -uroot -pfuckitshipit -Dauth

print_status "Creating character tables..."
cat /sql/base/characters_database.sql | mysql -hmysql -P3306 -uroot -pfuckitshipit -Dcharacters

print_status "Creating world tables and populating data..."
cat /sql/TDB_full_*.sql | mysql -hmysql -P3306 -uroot -pfuckitshipit -Dworld

print_status "Patchin' world with updates..."
for file in /sql/updates/world/*.sql; do
  bullet_list ${file}
  cat ${file} | mysql -hmysql -P3306 -uroot -pfuckitshipit -Dworld
done

print_status "Fixing ownership of created files"
  find /data -type d -exec chmod 777 {} \;
  find /data -type f -exec chmod 666 {} \;
