### ディレクトリ構造

```
[root@localhost tmp]# ls -l /tmp/
合計 24
-rwxr-xr-x 1 root root 133  3月 23 18:30 backend.sh
-rwxr-xr-x 1 root root   9  3月 23 18:30 backend1.sh
-rwxr-xr-x 1 root root   9  3月 23 18:30 backend2.sh
-rwxr-xr-x 1 root root   9  3月 23 18:31 backend3.sh
-rwxr-xr-x 1 root root   9  3月 23 18:31 backend4.sh
-rwxr-xr-x 1 root root   9  3月 23 18:31 backend5.sh

→こんな感じで配置
```

1. cd /tmp で移動
2. vi ファイル名 で作成

---
### それぞれの中身

- /tmp/backend.sh

```
#!/bin/bash

/root/backend1.sh 100 &
/root/backend2.sh 200 &
/root/backend3.sh 300 &
/root/backend4.sh 400 &
/root/backend5.sh 500 &

→別のスクリプトに第一引数を指定して(100,200,300,400,500)、バックグラウンドで実行(&)

```

- cat /tmp/backend1.sh

```
sleep $1

→スクリプト実行時の第一引数の時間 sleep
→ /tmp/backend1.sh 300 で実行すると sleep 300

```

- cat /tmp/backend2.sh

```
sleep $1
```

- cat /tmp/backend3.sh

```
sleep $1
```

- cat /tmp/backend4.sh

```
sleep $1
```
- cat /tmp/backend5.sh

```
sleep $1
```

---
### 実行までの流れ

- ファイルに実行権限を与える

```
chmod 755 /tmp/backend*

→後方一致(*),backendから始まるファイルの権限を一気に変更

```

- 現在のディレクトリの確認

```
[root@localhost tmp]# pwd
/tmp

```

- 親スクリプトを実行

```
パターン1
[root@localhost tmp]# ./backend.sh

パターン2
[root@localhost tmp]# /tmp/backend.sh

パターン3(デバック実行)
[root@localhost tmp]# bash -x backend.sh
+ ./backend1.sh 100
+ ./backend2.sh 200
+ ./backend3.sh 300
+ ./backend4.sh 400
+ ./backend5.sh 500

パターン4(デバック実行)
[root@localhost tmp]# bash -x ./backend.sh
+ ./backend1.sh 100
+ ./backend2.sh 200
+ ./backend3.sh 300
+ ./backend4.sh 400
+ ./backend5.sh 500

パターン5(デバック実行)
[root@localhost tmp]# bash -x /tmp/backend.sh
+ ./backend1.sh 100
+ ./backend2.sh 200
+ ./backend3.sh 300
+ ./backend4.sh 400
+ ./backend5.sh 500

```

- プロセスを確認(並列で実行できているか)

```
[root@localhost tmp]# ps aux

→プロセスを子プロセスを含めて階層で表示

root      6501  0.0  0.0 113180   868 pts/2    S    03:51   0:00 bash -x /tmp/backend.sh
root      6502  0.0  0.0 107952   356 pts/2    S    03:51   0:00 sleep 300
root      6503  0.0  0.0 107952   356 pts/2    S    03:51   0:00 sleep 200
root      6504  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 100
root      6505  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 500
root      6506  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 400
root      6507  0.0  0.0      0     0 ?        S    03:51   0:00 [kworker/0:2]
root      6508  0.0  0.0 155328  1888 pts/2    R+   03:51   0:00 ps aux

→それぞれの子プロセス(backend[1-5].sh)に値を渡して、その時間sleepできている

※プロセス名で絞る検索もある
[root@localhost tmp]# ps aux | grep sleep
root      6445  0.0  0.0 107952   360 pts/2    S    03:50   0:00 sleep 500
root      6458  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 400
root      6461  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 500
root      6470  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 400
root      6473  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 500
root      6483  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 500
root      6484  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 400
root      6493  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 500
root      6495  0.0  0.0 107952   356 pts/2    S    03:51   0:00 sleep 400
root      6505  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 500
root      6506  0.0  0.0 107952   360 pts/2    S    03:51   0:00 sleep 400
root      6512  0.0  0.0 112728   976 pts/2    S+   03:57   0:00 grep --color=auto sleep
```

- このサイトで勉強せよ

- [練習問題](http://g-network.boo.jp/wiki/2018/02/post-879/)
- [コマンドリファレンス](https://shellscript.sunone.me/)
