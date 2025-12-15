# DockerでROS2を開発するためのテンプレート

- Ubuntu 20.04
- ROS2 Humble

- CPU
- GPU

- terminator
- tmux


a





＃　メモ
以下のARG変数は自動的に設定される：
- TARGETPLATFORM : ビルド結果のプラットフォーム。例：linux/amd64、linux/arm/v7、windows/amd64。
- TARGETOS : TARGETPLATFORM の OS コンポーネント
- TARGETARCH : TARGETPLATFORM のアーキテクチャ コンポーネント
- TARGETVARIANT : TARGETPLATFORM のバリアント コンポーネント
- BUILDPLATFORM : ビルドを実行するノードのプラットフォーム。
- BUILDOS : BUILDPLATFORMのOSコンポーネント
- BUILDARCH : BUILDPLATFORMのアーキテクチャコンポーネント
- BUILDVARIANT : BUILDPLATFORMのバリアントコンポーネント
これらの引数はグローバルスコープで定義されるため、ビルドステージ内やRUNコマンドでは自動的に利用できません。

ビルドステージ内でこれらの引数を公開するには、値なしで再定義してください。
```
ARG TARGETPLATFORM \
    TARGETARCH \
    BUILDPLATFORM \
    BUILDARCH

RUN echo "TARGETPLATFORM=${TARGETPLATFORM} TARGETARCH=${TARGETARCH}" && \
    echo "BUILDPLATFORM=${BUILDPLATFORM} BUILDARCH=${BUILDARCH}"
```
```
$ docker buildx build --platform linux/amd64 .
```
