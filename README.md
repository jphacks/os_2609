# AR ダンジョン

屋内の会場を歩き回ってモンスターを集めて戦う、GPS 不要の AR ゲーム。

[![AR ダンジョン 紹介動画](https://github.com/user-attachments/assets/5f425729-2c37-4573-a817-c97156fbad55)](https://youtu.be/x18Ki4CH5r0)

▶ [紹介動画を見る(YouTube)](https://youtu.be/x18Ki4CH5r0)

## アプリのソースコード

| プラットフォーム | リポジトリ |
| --- | --- |
| iOS | [jphacks/os_2609-iOS](https://github.com/jphacks/os_2609-iOS) |
| Android | [jphacks/os_2609-android](https://github.com/jphacks/os_2609-android) |

## 製品概要
### 背景(製品開発のきっかけ、課題等）
展示会や学園祭などの屋内イベントでは、来場者が入口付近や目当てのブースだけを見て帰ってしまい、会場全体を歩いてもらうのは難しい。
位置情報ゲームのように「歩くこと」そのものを楽しくできれば、会場を回るきっかけになる。しかし屋内では GPS が届かないため、既存の位置情報ゲームの仕組みをそのまま持ち込めない。

### 製品説明（具体的な製品の説明）
「AR ダンジョン」は、屋内の会場を歩き回りながらモンスターを集めて戦う AR ゲーム。

* 最初に 3 体から相棒を 1 体選んでスタートする
* 会場を歩くと、カメラに映る床の上にモンスターが現れる（歩いた距離で出現するので、GPS がいらない）
* モンスターをタップするとバトルが始まる。画面をタップして攻撃し、スワイプで必殺技をよける。勝てば捕まえられる
* 捕まえたモンスターは図鑑に記録され、編成でバトルに出す相棒を選び直せる
* 会場で出会ったプレイヤーと、スマホを近づけてその場でリアルタイムに対戦できる（iOS と Android の間でも対戦できる）
* 会場マップで、自分が今どのチェックポイントにいるかがわかる（会場に置いた BLE ビーコンの電波の強さから推定する）

### 特長
#### 1. 屋内でも、歩くほどモンスターに出会える
GPS を使わず、ARKit がカメラで測る端末の移動距離でモンスターを出すので、屋内のどこでも遊べる。
会場に置いた 6 台のビーコンの電波の強さの組み合わせから、どのチェックポイントにいるかを推定してマップに表示する。歩いている間の揺れた電波は使わず、立ち止まったときに測ることで推定を安定させ、推定の信頼度も表示する。

#### 2. タップとスワイプだけで熱くなれる AR バトル
カメラに映る床の上で、3D のモンスター同士が戦う。画面をタップして攻撃し、必殺技の予告が出たらスワイプでよける。
攻撃しすぎるとスタミナが切れて休憩になり、フィーバーやチャンスの演出が駆け引きを生む。攻撃が当たった瞬間のヒットストップや振動で、手応えを出している。

#### 3. 目の前にいる人とだけ対戦できる
対戦の受付を ON にすると、近くの端末どうしが BLE で見つけ合い、電波が一番強い（一番近い）相手が候補に出る。お互いが「対戦する」を選ぶと、サーバーがその 2 人だけを組み合わせるので、遠くのプレイヤーとはつながらない。iOS と Android で同じしくみを使うので、OS が違っても会場で出会った人とその場で対戦できる。

### 解決出来ること
* **来場者に会場を歩き回ってもらうきっかけを作れる**：歩くほどモンスターに出会えるので、入口付近や目当てのブースだけで帰らず、会場を回る理由になる
* **屋内でも、大がかりな設備なしに位置と連動した体験を作れる**：使うのは、スマホと、会場に置く 1 台数千円の小さなマイコン 6 台だけ
* **知らない来場者どうしの交流が生まれる**：目の前にいる人とだけマッチングするので、会場で出会った人と、その場でモンスターを戦わせられる

### 今後の展望
* **エリアごとに出るモンスターを変える**：推定した現在地とモンスターの出現をつなげ、「奥のホールにだけレアモンスターがいる」のようにして、会場の奥まで足を運ぶ理由を作る
* **その場の全員で挑むレイドバトル**：同じエリアにいるプレイヤー全員で、ボスの HP を一緒に削る
* **主催者向けに人の流れを見える化する**：どのエリアに、いつ人が集まったかを集計し、会場づくりやブースの配置に活かす

### 注力したこと（こだわり等）
* **AR を安定して動かすこと**：捕獲とバトルで AR を切り替えると、画面が真っ黒になったり、床にモンスターを置けなくなったりした。原因は RealityKit の画面が同時に 2 つあることだったので、AR の画面は常に 1 つにし、カメラ映像のない 3D は SceneKit で描く形にした。捕獲からバトルへは AR セッションを引き継ぎ、床を探し直さずに、野生のモンスターがいた場所でそのまま戦える
* **iOS と Android で同じ体験をそろえること**：同じ 16 体のモンスター、同じバトルのルール、同じデータベースと近接対戦のしくみを使い、OS が違っても対戦できるようにした
* **屋内の位置推定を安定させること**：加速度センサーで歩いているかを見分け、立ち止まってから集めた電波だけで推定する。現在地が決まったらしばらく保持して飛びにくくし、推定の信頼度も出す

## 開発技術
### 活用した技術
#### API・データ
* Supabase：マルチバトル。近くの相手の確保と双方の承諾、対戦の部屋づくりは Postgres の関数（RPC）、攻撃などのやり取りは Realtime の変更通知で送り合う。iOS と Android で同じデータベースを使う
* Core Bluetooth（iOS）／ Bluetooth LE API（Android）：ビーコンの電波の強さ（RSSI）を受け取る。近くで対戦を受け付けている端末を見つける
* Core Motion（iOS）：歩いているか、立ち止まっているかを見分ける
* CryptoKit（iOS）：ビーコンの電波に付いた署名（HMAC-SHA256）を確かめる
* SwiftData（iOS）：捕まえたモンスターとバトルに出すモンスターを端末に保存する

#### フレームワーク・ライブラリ・モジュール
* iOS：SwiftUI、ARKit、RealityKit（AR の中の 3D）、SceneKit（カメラ映像なしの 3D と図鑑の画像）、supabase-swift
* Android（開発中）：Kotlin、Jetpack Compose、ARCore、SceneView（Filament）、supabase-kt
* ビーコン：Arduino（ESP32、Raspberry Pi Pico W のファームウェア）
* 3D モデル：Quaternius「Ultimate Monsters」（CC0 のフリー素材）。Blender のスクリプトで iOS 用の USDZ に変換し、14 種類のアニメーションを 1 本にまとめた（アプリ側で区間を切り出して流す）

#### デバイス
* iPhone 15（デモ機）
* Android 端末（ARCore 対応機種）
* BLE ビーコン 6 台：ESP32 × 3、M5Stack（ESP32-S3）× 1、Raspberry Pi Pico W × 1、Raspberry Pi Pico 2 W × 1

### 独自技術
#### ハッカソンで開発した独自機能・技術
* **目の前の相手とだけマッチングする**：BLE は近くの候補を見つけるためだけに使い、電波が一番強い相手を候補にする。相手の確保、双方の承諾、辞退は Supabase の関数で共有し、2 人とも承諾したときだけ、その 2 人専用の 1 回限りのトークンで対戦の部屋を合わせる。対戦の中身は BLE ではなく Supabase で送る。iOS と Android で同じしくみを使う
  * [ARApp/Services/NearbyBattleDiscovery.swift](https://github.com/jphacks/os_2609-iOS/blob/main/ARApp/Services/NearbyBattleDiscovery.swift)、[supabase/schema.sql](https://github.com/jphacks/os_2609-iOS/blob/main/supabase/schema.sql)
* **iOS と Android の間のリアルタイム対戦**：Supabase の Postgres の関数で対戦の部屋をつくり、攻撃やよけるといった行動を Realtime の変更通知で送り合う。iOS と Android で、行動の名前とルールの数値をそろえている
  * [ARApp/Services/SupabaseBattleService.swift](https://github.com/jphacks/os_2609-iOS/blob/main/ARApp/Services/SupabaseBattleService.swift)
* **歩いた距離でモンスターを出す・反射する床でも置ける**：ARKit で測った端末の移動距離でモンスターを出す。光を反射する床は床として判定されにくいので、カメラの高さとの差から床を見分ける
  * [ARApp/Views/Capture/AR/ARSceneController.swift](https://github.com/jphacks/os_2609-iOS/blob/main/ARApp/Views/Capture/AR/ARSceneController.swift)
* **立ち止まったときだけ測る屋内の位置推定**：加速度センサーで歩行を見分け、停止後 3 秒間の電波の中央値を、各チェックポイントで測っておいた値と比べる。決まった現在地は 5 秒保持し、誤差の大きさと 2 番目の候補との差から信頼度を出す
  * [ARApp/ViewModels/LocationViewModel.swift](https://github.com/jphacks/os_2609-iOS/blob/main/ARApp/ViewModels/LocationViewModel.swift)
* **ビーコンのなりすまし対策**：ビーコンの電波に、回る番号と HMAC-SHA256 の署名を入れ、アプリ側で本物のビーコンかを確かめる
  * [ARApp/Services/BeaconAdvertisementAuthenticator.swift](https://github.com/jphacks/os_2609-iOS/blob/main/ARApp/Services/BeaconAdvertisementAuthenticator.swift)、[firmware/rssi/beacon_advertisement_auth.h](https://github.com/jphacks/os_2609-iOS/blob/main/firmware/rssi/beacon_advertisement_auth.h)
