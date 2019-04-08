#!/bin/sh

# サーバ内の「パッケージに属していないシェルスクリプト」を検索して
# 新しいサーバにディレクトリ情報を保持したまま、コピーするシェルスクリプト

# 以前使用したファイルがあれば削除
rm /tmp/SHELLfile

# 各ディクトリのシェルスクリプトを探して
# そのファイルの絶対パスをファイル（SHELLfile）にリダイレクト
find /backup -name '*.sh'>> /tmp/SHELLfile
find /boot -name '*.sh' >> /tmp/SHELLfile
find /dev -name '*.sh' >> /tmp/SHELLfile
find /etc -name '*.sh' >> /tmp/SHELLfile
find /home -name '*.sh' >> /tmp/SHELLfile
find /media -name '*.sh' >> /tmp/SHELLfile
find /mnt -name '*.sh' >> /tmp/SHELLfile
find /opt -name '*.sh' >> /tmp/SHELLfile
find /proc -name '*.sh' >> /tmp/SHELLfile
find /root -name '*.sh' >> /tmp/SHELLfile
find /run -name '*.sh' >> /tmp/SHELLfile
find /srv -name '*.sh' >> /tmp/SHELLfile
find /sys -name '*.sh' >> /tmp/SHELLfile
find /tmp -name '*.sh' >> /tmp/SHELLfile
find /usr -name '*.sh' >> /tmp/SHELLfile
find /var -name '*.sh' >> /tmp/SHELLfile

# 転送したいサーバのIPを入力
IP=172.16.13.27

# SHELLfile（シェルスクリプトの絶対パスが記載されたファイル）の中身を
# 「while read LINE」を使い、一行ずつ読み込んで処理
while read LINE
do

# 「rpm -qf」を使い、シェルスクリプトがパッケージに属するものかを判断
rpm -qf ${LINE}

# 「属さないもの=終了ステータスが1」であれば
# 「dirname」を使い、パス名を取得

if [ $? -eq 1 ]; then
  DIRNAME=`dirname ${LINE}`

# sshに「-n」を付けてバックグラウンドで実行し、転送先のサーバにディレクトリを作成
# scpに「-p」を付けてタイムスタンプを保持し、「パッケージに属していないシェルスクリプト」を転送

  ssh -n ${IP} "mkdir -p ${DIRNAME}"
  scp -p ${LINE} root@${IP}:${LINE}
fi

done</tmp/SHELLfile
