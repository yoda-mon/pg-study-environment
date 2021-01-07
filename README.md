PostgreSQLを学習するための環境の一例。mac推奨。
※ローカル環境での学習を想定しているので、外部公開されているサーバー上にデプロイはしないよう重々留意

## TL;DR

```sh
sh start.sh # 走行
sh stop.sh  # 停止
sh clear_data.sh   # データ削除（注意）
```

## 環境構築手順
### 1. Docker Desktop for Macのインストール
https://hub.docker.com/editions/community/docker-ce-desktop-mac/
よりDocker Desktop for Macをインストール、起動しておく

### 2. docker-compose.ymlの編集
`POSTGRES_PASSWORD=bigdata`の部分を自身のパスワードに書き換える  

Jupyterからのアクセスを行いたい場合は、Pythonで

```python
from notebook.auth import passwd
passwd('bigdata')   # => sha1xxx...
```

を実行しパスワードを取得、
`--NotebookApp.password=sha1:5330fe11ec03:9204c084c78cc72529b7e8835aa687341db6f569`
の部分を書き換える

### 3. 起動
docker-compose.ymlのあるディレクトリで、

```sh
docker-compose up -d
```

### 4. DBアクセス
#### 起動したpostgres-clientから
クライアントのコンテナへログイン
```sh
docker exec -it study-postgres-client bash
```

```sh
PGPASSWORD=bigdata psql -h postgres-server -p 5432 -U postgres  # PGPASSWORDは各自設定した環境変数とする
```

#### ホストのmacから

```sh
PGPASSWORD=bigdata psql -h localhost -p 5432 -U postgres  # PGPASSWORDは各自設定した環境変数とする
```

#### Jupyterから
http://localhost:8888 へアクセスし、YAMLに記載した（ハッシュの元になった）パスワードを入力する

そのあとは`work/sample.ipynb`を参照のこと


### 5. 停止

```sh
docker-compose down 
```

## 注意点
- 必要なければ、`postgres-client`と`jupyter`はYAMLからコメントアウト
- `postgres-server`のデータは`/data/pgdata`に、`jupyter`のデータは`/data/work`に保存されるようにマウントしている。必要に応じて削除することで全消去可能
  - PostgreSQLの公式イメージは、`PG_DATA`直下のファイルの有無で初期化実行判断をするため、消したはずなのに消えてないという場合は`/data/pgdata`にファイルが残っている場合がある。
