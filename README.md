# DockerでROSを開発するためのテンプレート

- Ubuntu 20.04
- ROS Noetic

- CPU
- GPU

- terminator
- tmux


# ROS Noetic Ninjemys
Ubuntu 22.04 LTS (Jammy Jellyfish)

- okdhryk/ros:noetic-destop-full
- okdhryk/cuda:12.9.1-cudnn-devel-noetic-desktop-full


[CPU環境でRVizを動かす問題](https://memoteki.net/archives/9255)

[GPU環境](https://github.com/turlucode/ros-docker-gui)


## ToDo
PulseAudio 経由でのみ再生可能

正解コマンド：

aplay -D pulse output2.wav





## ホストPCのディレクトリの共有
初めて実行する前の大事な注意

Dockerコンテナでおこなった、ディレクトリの作成やファイルの編集、パッケージのインストールなどはDockerイメージには反映されず、
コンテナが破棄された時点で消えてしまいます。
オブジェクト指向で言うところのクラス（Dockerイメージ）とインスタンス（Dockerコンテナ）の関係です。
そこで、ホストコンピュータのディレクトリをコンテナにマウントし共有します。
このようにすれば、相互にマウントしたディレクトリ内での編集作業が消えることはありません。

### ホストコンピュータとコンテナ間で共有するディレクトリの作成
コンテナを初めて起動するする前に、事前の準備として下記の通り、ホストコンピュータにディレクトリを作成しておいてください。
```
(host)$ cd ~
(host)$ mkdir share
```
ここでは"share"という名前のディレクトリを作成しています。
共有するディレクトリの名前は .envファイルで指定します。

### 事前に共有ディレクトリを作成しなかった場合
事前に共有ディレクトリを作成しなかった場合、Dockerシステムは共有ディレクトリを自動的に作成します。
ただし、自動的に作成された共有ディレクトリはroot権限で作成されるため、書き込みが自由にできないディレクトリになってしまいます。
そのような場合はコンテナを停止した後に、ホストコンピュータで下記のように共有したいディレクトリのユーザとグループを変更してください。
```
(host)$ ls -al ~/share
合計 8
drwxr-xr-x  2 root   roor     4096 12月 31 23:29 .
drwxr-x--- 24 ユーザ名 グループ名 4096 12月 31 23:29 ..
```
```
(host)$ sudo chown ユーザ名 ~/share/
(host)$ sudo chgrp グループ名 ~/share/
```
共有ディレクトリのユーザ名とグループ名が変更されているか確認します。
```
(host)$ ls -al ~/share
合計 8
drwxr-xr-x  2 ユーザ名 グループ名 4096 12月 31 23:31 .
drwxr-x--- 24 ユーザ名 グループ名 4096 12月 31 23:31 ..
```



## .envファイルの設定
1. `.env`というファイルを作成する
2. `.env_template`の内容をコピーして.envに貼り付ける
3.  ユーザ名，グループ名，ユーザID，グループID，パスワード，ホストPCと共有するディレクトリを記述する


## Docker イメージのビルド
```
(host)$ cd ~/docker_images/ros/noetic
```

```
(host)$ make build_cpu
```
```
(host)$ make build_gpu
```
```
(host)$ make build
```

## コンテナの実行
```
(host)make run_cpu
```

```
(host)make run_gpu
```


 
