### 画面遷移図
Figma：https://www.figma.com/design/ncVnonAehn7mboKRKmKwrH/LeafWhisper?node-id=0-1&t=gEt8qP1X9njYsoxO-1

ER図：https://gyazo.com/9659c00c1af4ec3330199accdd69b717

■サービス概要
日本茶に関する情報を集約した、日本茶に関する商品やカフェの検索・レビューを提供出来るアプリです。
様々な日本茶に関する商品や、カフェのレビューを投稿・閲覧することが可能です。日本茶愛好家や、日本茶に関心がある方が情報を共有することによって交流する事も出来ます。

■ このサービスへの思い・作りたい理由
自身が幼い頃から日本茶（特に抹茶）に関する物が好きで、現在も定期的に自分で調べた日本茶が楽しめそうなカフェなどに足を運んでおります。そこで、私の様な日本茶愛好家が、容易に日本茶に関連した商品・カフェなどの情報に辿り着く事が出来るプラットフォームがあれば便利などではないかと思いました。
また、同様な嗜好を持つ他の方とも、レビューなどを通して情報交換が出来る手段があれば、ユーザーにとってもより楽しみながらサービスを使用することが出来、まだ日本茶に関心があるだけという方にとっても、実際に日本茶関連商品・カフェを体験する良い足掛かりとなるのではないかと思いました。
このサービスをきっかけに、日本茶に関心を持っていただける方が増えていってくれればという思いがあります。

■ ユーザー層について
日本茶愛好家 - 既に日本茶に一定の関心があるので、日本茶に関する情報を共有出来ることに価値を感じる事が予測出来る為。
健康志向のユーザー - 日本茶の健康効果が高いことは有名なので、健康を意識している方にとって、日本茶に関する商品を試してみるきっかけになる事が考えられる為。
外国人 - 日本茶（特に抹茶）は海外でも大変有名な為、多言語対応機能を設ける事により、彼らにとっても情報収集がしやすくなる為。
日本茶に興味がある初心者 - これから日本茶を試してみたいという方にとって、様々なユーザーから集められた信頼出来るレビューなどを参照出来るプラットフォームはニーズを満たしていると考えられる為。

■サービスの利用イメージ
日本茶関連の商品・カフェの検索とレビュー投稿・閲覧機能を利用する事により、ユーザーは自分の好みに合った商品・カフェを見つけやすくなります。また、他のユーザーから見た客観的な情報を頼りにする事で、より良い選択が出来る様になります。

■ ユーザーの獲得について
Xでのシェア機能を主に活用し、幅広く日本茶に興味がある方に関心を持っていただける様にしようと考えております。
また、今はまだ関心があるけれど日本茶についてよく分からないという方に向けても、Q＆Aのセクションを設けることにより、より容易に情報を得られる様にする予定です。

■ サービスの差別化ポイント・推しポイント
一つのプラットフォームで様々な日本茶の情報を網羅している為、ユーザーにとって効率良く情報収集をする事が出来ます。
また、日本語と英語に対応しており、多言語に対応した日本茶専門サイトは少ない為、他サイトとの差別化を図れます。
位置情報検索機能を使用し、ユーザーは近くの日本茶専門カフェを簡単に見つけらる事が出来る為、単に近くにあるカフェを探している方や、観光客にとっても便利に使用することが出来ます。

■ 機能候補
## 実装を予定している機能
### MVP
* ユーザー登録機能
* ユーザー情報編集機能
* ログイン機能（Google認証）
* ログアウト機能
* 商品検索機能
* 商品詳細確認機能
* 日本茶専門カフェ検索機能（Google Maps APIを使用）
* 日本茶専門カフェ詳細確認機能
* SNS(X)へのシェア機能
* レビュー投稿機能
* レビュー編集機能
* お気に入り追加機能
* お気に入りリスト確認機能

■ 機能の実装方針予定
* パスワードリセット機能
* ゲストログイン機能
* 多言語対応機能（英語）
* 検索オートコンプリート機能
* 日本茶に関するQ＆A機能
* お問い合わせ、利用規約、プライバシーポリシー

■ 使用予定の技術
* フロントエンド - tailwindCSS/DaisyUI/Hotwire/Javascript
* バックエンド　-　Ruby 3.3.3/Rails 7.1.3.3
* データベース - PostgreSQL
* 環境構築 - Docker
* インフラ - Render/Amazon S3
* API - 楽天市場商品検索API/Google Maps API