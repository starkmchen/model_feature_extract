#!/bin/bash
set -x
day=$(date -d "1 day ago" +%Y%m%d)
aws=/usr/local/bin/aws

echo $day

function file_exist()
{
dname=$1
while [ 1 ];do
  f_succ=$($aws s3 ls $dname/_SUCCESS)
  if [ -n "$f_succ" ];then
    echo $dname, $f_succ
    break
  fi
  sleep 600
done
}

rm -rf /root/ads_train_data_cvr/$day
mkdir /root/ads_train_data_cvr/$day

ls /root/train_data/$day/p* | xargs python extract_feature_cvr.py

cd /root/ads_train_data_cvr/$day

mkdir feature_index
mkdir pre_data
mkdir train_data
mv part-0019* pre_data
mv part* train_data
cp /root/nt_ad/feature_index feature_index
touch _SUCCESS
