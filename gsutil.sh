#переходим в /tmp

cd /tmp

#копируем файлы из gcp/storage

gsutil -m cp -R gs://taxi_trips_2020_10 .