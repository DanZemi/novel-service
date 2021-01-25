# NovelService

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
# novel-service


2021/01/24 -> test discord

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
│   ├── templates   ----------------------> 画面表示部分(view)
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
│   └── views ---------------------------> 大事かもしれんけどよくわかってない
│       ├── article_view.ex
│       ├── error_helpers.ex
│       ├── error_view.ex
│       ├── layout_view.ex
│       ├── session_view.ex
│       └── user_view.ex
└── novel_service_web.ex
</pre>