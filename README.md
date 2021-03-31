# Branch-Novelsとは？
分岐機能や統合機能を搭載したオープンソース型小説投稿サービスです。

## 背景・概要

近年、小説や漫画の二次創作における著作権の問題がグレー化されています。<br>
そこで、このサービス内ではサービスに投稿される一次創作作品の二次創作を全面的に許可することで、本家
とは違う展開のストーリーを書いたり(分岐)、キャラクターは同じで全く違うス
トーリーを書いたり(パラレルワールド)することができます。
<br>
![image](https://user-images.githubusercontent.com/50546239/113131585-5ec9e880-9258-11eb-8591-a5c4b0eb6db0.png)

## 今後の課題
- 分岐機能
- 統合機能
- Oauth


# BranchNovels URL
[Here!](https://branchnovels.gigalixirapp.com/)


#### 自分用コード把握
<pre>
lib
├── novel_service
│   ├── accounts
│   │   ├── error_handler.ex
│   │   ├── guradian.ex
│   │   ├── pipeline.ex
│   │   └── user.ex -----------------------> userのschemaとかバリデーションとか
│   ├── accounts.ex -----------------------> userのデータ処理(model)
│   ├── application.ex
│   ├── novel
│   │   └── article.ex  -------------------> novelのschemaとかバリデーションとか
│   ├── novel.ex --------------------------> novelのデータ処理(model)
│   └── repo.ex
├── novel_service.ex
├── novel_service_web
│   ├── channels
│   │   └── user_socket.ex
│   ├── controllers -----------------------> viewとmodelsの橋渡しの部分(controller)
│   │   ├── article_controller.ex
│   │   ├── session_controller.ex
│   │   └── user_controller.ex
│   ├── endpoint.ex
│   ├── gettext.ex
│   ├── live
│   │   ├── page_live.ex
│   │   └── page_live.html.leex
│   ├── router.ex
│   ├── telemetry.ex
│   ├── templates   ----------------------> 画面表示部分
│   │   ├── article
│   │   │   ├── edit.html.eex
│   │   │   ├── form.html.eex
│   │   │   ├── home.html.eex
│   │   │   ├── index.html.eex
│   │   │   ├── mynovellists.html.eex
│   │   │   ├── new.html.eex
│   │   │   ├── rank.html.eex
│   │   │   ├── show.html.eex
│   │   │   └── summary.html.eex
│   │   ├── layout
│   │   │   ├── app.html.eex
│   │   │   ├── live.html.leex
│   │   │   └── root.html.leex
│   │   ├── session
│   │   │   └── new.html.eex
│   │   └── user
│   │       ├── edit.html.eex
│   │       ├── form.html.eex
│   │       ├── index.html.eex
│   │       ├── myinfo.html.eex
│   │       ├── mypage.html.eex
│   │       ├── new.html.eex
│   │       ├── show.html.eex
│   │       └── userinfo.html.eex
│   └── views ---------------------------> ブラウザやAPIクライアントに送信されるレスポンスの本文をレンダリングする
│       ├── article_view.ex
│       ├── error_helpers.ex
│       ├── error_view.ex
│       ├── layout_view.ex
│       ├── session_view.ex
│       └── user_view.ex
└── novel_service_web.ex
</pre>
