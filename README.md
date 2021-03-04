# url
http://hryk-mythicalmysfits.s3-website-us-east-1.amazonaws.com

# codecommitにssh接続
codecommitにssh接続する際は、以下を~/.ssh/configなどに追加
clone先は「git clone ssh://git-codecommit.(resion"us-east-1"等).amazonaws.com/v1/repos/(codecommitのレポジトリ名)」

ex. git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/MythicalMysfitsService-Repository .

> Host git-codecommit.*.amazonaws.com
>    User APKXXXXXXXXXXXXXXXXXXX(AIMユーザのAWS CodeCommitの認証情報SSHキー/SSHキーID)
>    IdentityFile ~/.ssh/id_rsa(id_rsaはキーファイル名)