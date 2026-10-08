# Sunshine

JPHACKS 2026 で開発する iOS アプリ（SwiftUI）。

- リポジトリ: https://github.com/jphacks/os_2609
- 対応 OS: iOS 17.6 以上（iPhone / iPad）
- 言語: Swift / SwiftUI
- テスト: Swift Testing（`import Testing`, `@Test`, `#expect`）

## アーキテクチャ: MVVM

```
Sunshine/
├── App/          # SunshineApp.swift（エントリポイント）
├── Models/       # データ構造（struct 中心、UI に依存しない）
├── ViewModels/   # 画面ごとの状態とロジック
├── Views/        # SwiftUI の View
│   └── Components/   # 複数画面で使う小さな View
├── Services/     # API 通信・永続化・センサーなど外部とのやり取り
└── Assets.xcassets
```

### 各層のルール

- **View**
  - 表示とユーザー操作の受け付けだけを行う。ビジネスロジックや通信は書かない
  - ViewModel は `@State private var viewModel = XxxViewModel()` で保持する
  - 子 View に渡すときは `@Bindable` か値そのものを渡す
  - 必ず `#Preview` を付ける
- **ViewModel**
  - `@Observable final class XxxViewModel` で定義する（`ObservableObject` / `@Published` は使わない）
  - 1 画面につき 1 つ。名前は `XxxView` に対して `XxxViewModel`
  - `import SwiftUI` しない（`Foundation` / `Observation` のみ）。View の型を持たない
  - Service はイニシャライザで受け取る（テストでモックに差し替えられるように）
- **Model**
  - `struct` で定義し、必要に応じて `Codable`, `Identifiable`, `Hashable`, `Sendable` に準拠する
- **Service**
  - `protocol XxxServiceProtocol` を定義し、実装は `XxxService`
  - 非同期処理は `async throws` で書く（Combine やコールバックは使わない）

### 例

```swift
// Models/Item.swift
struct Item: Identifiable, Codable, Sendable {
    let id: UUID
    var title: String
}

// Services/ItemService.swift
protocol ItemServiceProtocol: Sendable {
    func fetchItems() async throws -> [Item]
}

// ViewModels/ItemListViewModel.swift
import Observation

@Observable
final class ItemListViewModel {
    private(set) var items: [Item] = []
    private(set) var isLoading = false
    var errorMessage: String?

    private let service: ItemServiceProtocol

    init(service: ItemServiceProtocol = ItemService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            items = try await service.fetchItems()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// Views/ItemListView.swift
struct ItemListView: View {
    @State private var viewModel = ItemListViewModel()

    var body: some View {
        List(viewModel.items) { item in
            Text(item.title)
        }
        .task { await viewModel.load() }
    }
}
```

## プロジェクト設定の注意

- **Default Actor Isolation = MainActor**（アプリターゲット）。型は明示しなくても `@MainActor` 扱いになる。重い処理をバックグラウンドで動かしたい場合は `nonisolated` や `@concurrent` を付ける
- Xcode の **フォルダ同期**（File System Synchronized Group）を使っているので、`Sunshine/` 配下にファイルを置けば自動でターゲットに追加される。`project.pbxproj` を手で編集する必要はない
- API キーなどの秘密情報は `Secrets.swift` に書く（`.gitignore` 済み）。コードに直接書かない

## ビルド・テスト

```sh
# ビルド
xcodebuild -project Sunshine.xcodeproj -scheme Sunshine \
  -destination 'platform=iOS Simulator,name=iPhone 17' build

# テスト
xcodebuild -project Sunshine.xcodeproj -scheme Sunshine \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

ViewModel を変更したら、対応するテストを `SunshineTests/` に追加・更新する。

## Git

- **コミットメッセージは日本語**で書く
  - 1 行目に変更内容を簡潔に（例: `ログイン画面を追加`、`天気取得APIのエラー処理を修正`）
  - 必要なら空行を挟んで詳細を書く
- ブランチ名は英語: `feature/xxx`, `fix/xxx`
- `main` への force push はしない
