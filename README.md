# NIFTY Cloud Packer Templates

ニフティクラウドのスタンダードイメージ、パブリックイメージをビルドするための [Packer][1] テンプレート集です。

活用事例として、ニフティクラウドユーザーブログにて、記事を公開しています。

[FreeBSDのパブリックイメージを公開しました！][2]

## 注意事項

* このテンプレート集は、サポート対象外のため、ご利用は自己責任でお願いいたします。

## 概要

ニフティクラウド上で正常にサーバーを動作させるには、下記の条件が必要です。

* 仮想 NIC が2つ付いていること
* VMware 公式 VMware Tools が動作していること
* ニフティクラウド独自の[OS初期化スクリプト][3]が正しくインストールされていること

これらを満たしたイメージを作成するため、ニフティクラウドでは、 Packer を用いて、イメージのビルドを自動化しています。

## 環境

下記の環境が必要です。

* Packer が動作するクライアントOS
* Packer 0.6.0 以上
* ESXi 5.1 以上
    * SSH が有効
    * 後述する GuestIPHack が有効
    * ファイアウォールにて、 VNC で使用するポートが開いていること

## 準備

### Packer のインストール

OSによってインストール方法が異なるため、詳細は割愛しますが、 [Packer のダウンロードページ][4]から、クライアントOSにあった実行ファイルをダウンロードした上で、ダウンロードした実行ファイルを解凍し、パスを通します。

`packer -v` を実行し、 Packer のバージョンが表示されれば、正しくインストールできています。

詳しくは、公式ページのインストール方法をご参照ください。

<http://www.packer.io/docs/installation.html>

### ESXi のファイアウォールの設定

1. vSphere Client で対象の ESXi にログインします。
1. Configuration タブを開きます。
1. 左メニューから、 Security Profile を選択します。
1. Firewall の Propertie... を開きます。
1. VM serial port connected over network にチェックを入れ、 OK を選択します。

上記の設定ではTCPの23と1024から65535ポートが開放されますが、多すぎるという方は必要なポートのみ開放することが可能です。

詳細な手順は下記の VMware の KB をご参照ください。

[Creating custom firewall rules in VMware ESXi 5.x (2008226)][5]

### ESXi の GuestIPHack の有効化

VMware Tools が起動していない仮想マシンの IP を取得するため、 GuestIPHack を有効にします。

ESXi に SSH でログインして、下記のコマンドを実行します。

```
esxcli system settings advanced set -o /Net/GuestIPHack -i 1
```

## ビルド方法

ビルドしたい OS のディレクトリに移動してから、 `packer build` コマンドを実行します。

ここでは、例として下記のような環境の場合のコマンドを記載します。

* ESXi の IP アドレス: `192.168.0.4`
* データストア名: `datastore`
* 1つめのNICのポートグループ名: `portgroup-1`
* 2つめのNICのポートグループ名: `portgroup-2`

```
packer build \
-var remote_host=192.168.0.4 \
-var remote_datastore=datastore \
-var network1=portgroup-1 \
-var network2=portgroup-2 \
template.json
```

* ビルドが完了すると、 datastore 内の `/vmfs/volumes/datastore/OS名` 配下に VMX ファイルと VMDK ファイルが生成されます。
* この後は、 [ovftool][6] でOVFに変換してデプロイしたり、 ESXi に再登録したりすることで、ニフティクラウドのサーバーと同じ構成の VM イメージを利用可能です。

## デバッグ

packer コマンドの前に `PACKER_LOG=1` を付けると詳細なログが出力され、 `PACKER_LOG_PATH=build.log` を付けると `build.log` に出力されます。

## その他

* ビルド時の SSH 接続で、 `ssh_key` ディレクトリ配下の鍵を利用していますが、安全のため、ご自身の SSH 鍵と入れ替えることをおすすめします。
* 作成した VM イメージを VM インポートする場合は、下記ヘルプページをご参照ください。

[VMイメージの作成方法][7]

* Pull Request や Issue の登録はお気軽にどうぞ。

 [1]: http://www.packer.io/
 [2]: http://blog.cloud.nifty.com/2104/ 
 [3]: http://cloud.nifty.com/help/os/os_init.htm
 [4]: http://www.packer.io/downloads.html
 [5]: http://kb.vmware.com/kb/2008226
 [6]: https://www.vmware.com/support/developer/ovf/
 [7]: http://cloud.nifty.com/help/basic/server_vm_new.htm
