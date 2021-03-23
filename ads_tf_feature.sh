#!/bin/bash
set -x
day=$(date -d "1 day ago" +%Y%m%d)
aws=/usr/local/bin/aws
cwd=$(pwd)

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


function download_train_data()
{
file_exist s3://sprs.push.us-east-1.prod/data/warehouse/model/train_data/$day
rm -rf /root/train_data/$day
$aws s3 sync s3://sprs.push.us-east-1.prod/data/warehouse/model/train_data/$day /root/train_data/$day
}

function gen_ctr_data()
{
tf_data_dir=/root/ads_train_data/$day
rm -rf $tf_data_dir
mkdir $tf_data_dir

cd $cwd
ls /root/train_data/$day/p* | xargs python extract_feature.py

cd $tf_data_dir

mkdir feature_index
mkdir pre_data
mkdir train_data
mv part-0019* pre_data
mv part* train_data
cp /root/nt_ad/feature_index feature_index
touch _SUCCESS
}


function gen_cvr_data()
{
tf_data_dir=/root/nt_ads_train_data_cvr/$day
rm -rf $tf_data_dir
mkdir $tf_data_dir

cd $cwd
ls /root/train_data/$day/p* | xargs python extract_feature_cvr.py

cd $tf_data_dir

mkdir feature_index
mkdir pre_data
mkdir train_data
mv part-0019* pre_data
mv part* train_data
cp /root/nt_ad/feature_index feature_index
touch _SUCCESS
}

download_train_data
gen_ctr_data
gen_cvr_data
