# GitHub Actions で Swift プロジェクトの CI/CD を構築する

このプロジェクトでは、GitHub Actions を使用して Swift プロジェクトの継続的インテグレーション（CI）を実装しています。

## 📁 ファイル構成

```
.github/
└── workflows/
    ├── ci.yml              # メインのCI/CDワークフロー
    └── simple-build.yml    # シンプルなビルドのみのワークフロー
.swiftlint.yml              # SwiftLintの設定ファイル
.swiftformat                # SwiftFormatの設定ファイル
.swift-version              # Swiftバージョン指定ファイル
```

## 🚀 GitHub Actions とは

GitHub Actions は、GitHub が提供する CI/CD（継続的インテグレーション/継続的デプロイメント）プラットフォームです。リポジトリで特定のイベント（プッシュ、プルリクエストなど）が発生したときに、自動的にワークフローを実行できます。

### 主な利点

- **自動化**: コードの変更時に自動でビルドとテストを実行
- **品質保証**: 問題のあるコードがメインブランチにマージされるのを防ぐ
- **時間節約**: 手動でのビルドやテストが不要
- **統合性**: GitHub 上で全ての開発フローを管理

## 📋 ワークフローの説明

### 1. メインワークフロー (`ci.yml`)

```yaml
name: CI
on:
  push:
    branches: [main, master] # mainブランチへのプッシュ時
  pull_request:
    branches: [main, master] # プルリクエスト作成時
  workflow_dispatch: # 手動実行
```

**実行される処理:**

- ✅ プロジェクトのビルド
- 🧪 テストの実行
- 🔍 SwiftLint によるコード品質チェック
- 📝 SwiftFormat によるフォーマットチェック

### 2. シンプルワークフロー (`simple-build.yml`)

最低限のビルドのみを行うシンプルな例です。GitHub Actions 初心者の方におすすめです。

## 🛠 設定方法

### 1. ファイルの配置

このプロジェクトではすでに設定済みですが、新しいプロジェクトでは以下を実行：

```bash
# ワークフローディレクトリを作成
mkdir -p .github/workflows

# ワークフローファイルを作成
touch .github/workflows/ci.yml
```

### 2. GitHub 上での確認

1. GitHub リポジトリページの「Actions」タブをクリック
2. ワークフローの実行状況を確認
3. 失敗した場合は、ログを確認して問題を修正

## 🎯 トリガーの種類

GitHub Actions は様々なイベントで実行できます：

```yaml
on:
  push: # プッシュ時
    branches: [main]
  pull_request: # プルリクエスト時
    branches: [main]
  schedule: # 定期実行
    - cron: "0 0 * * *" # 毎日午前0時
  workflow_dispatch: # 手動実行
  release: # リリース作成時
    types: [published]
```

### 📋 プルリクエストのトリガーについて詳しく解説

```yaml
pull_request:
  branches: [main, master] # ターゲットブランチを指定
```

**重要なポイント：**

1. **ターゲットブランチが重要**:

   - `branches: [ main, master ]` は **マージ先（ターゲット）ブランチ** を指定
   - 例：`feature/test` → `master` への PR なら実行される ✅
   - 例：`feature/test` → `develop` への PR なら実行されない ❌

2. **ソースブランチは何でも OK**:

   - `feature/test`, `bugfix/issue-123`, `hotfix/urgent` など、どんなブランチ名でも可能
   - 重要なのは PR の**マージ先**が main または master であること

3. **実行タイミング**:
   - PR 作成時
   - PR への新しいコミットのプッシュ時
   - PR の再オープン時

### 🔧 より柔軟な設定例

```yaml
# 例1: 特定のブランチへのPRのみ
on:
  pull_request:
    branches: [ main ]        # mainブランチへのPRのみ

# 例2: 特定のブランチからのPRのみ
on:
  pull_request:
    branches: [ main ]
    # ソースブランチも制限したい場合（通常は不要）
    # ただし、この書き方は直接サポートされていない

# 例3: パターンマッチング
on:
  pull_request:
    branches:
      - main
      - 'release/**'        # release/v1.0, release/v2.0 など

# 例4: 除外パターン
on:
  pull_request:
    branches:
      - main
    branches-ignore:
      - 'experimental/**'   # experimental ブランチは除外
```

### 📊 実際の動作例

| PR の内容                  | 実行される？ | 理由                           |
| -------------------------- | ------------ | ------------------------------ |
| `feature/login` → `main`   | ✅ Yes       | ターゲットが main              |
| `bugfix/auth` → `master`   | ✅ Yes       | ターゲットが master            |
| `feature/test` → `develop` | ❌ No        | ターゲットが develop（対象外） |
| `hotfix/urgent` → `main`   | ✅ Yes       | ターゲットが main              |

### 🎮 workflow_dispatch について

```yaml
workflow_dispatch: # 手動実行
  inputs: # 手動実行時のパラメータ（オプション）
    environment:
      description: "Environment to deploy to"
      required: true
      default: "staging"
      type: choice
      options:
        - staging
        - production
    version:
      description: "Version to deploy"
      required: false
      default: "latest"
```

**手動実行の特徴：**

- GitHub の Actions タブから任意のブランチで実行可能
- ブランチの制限なし（どのブランチからでも実行可能）
- パラメータを設定して柔軟な実行が可能

## 🔧 カスタマイズ例

### セキュリティスキャンの追加

```yaml
- name: Security Scan
  run: |
    # セキュリティの脆弱性をチェック
    swift package show-dependencies --format json | jq '.'
```

### Slack 通知の追加

```yaml
- name: Slack Notification
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: failure
    channel: "#development"
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

### アーティファクトの保存

```yaml
- name: Archive build artifacts
  uses: actions/upload-artifact@v4
  with:
    name: build-artifacts
    path: |
      *.app
      *.ipa
```

## 📊 ステータスバッジ

README.md にビルドステータスを表示：

```markdown
![CI Status](https://github.com/username/repository/workflows/CI/badge.svg)
```

### 🐛 トラブルシューティング

### よくある問題と解決策

1. **ビルドが失敗する**

   - Xcode/Swift のバージョンを確認
   - 依存関係の問題を確認

2. **テストが失敗する**

   - シミュレーターの設定を確認
   - テストケースの修正

3. **SwiftLint エラー**

   - `.swiftlint.yml` の設定を調整
   - コードスタイルを修正

4. **SwiftFormat エラー**
   - コードを自動フォーマット: `swiftformat .`
   - 設定ファイル `.swiftformat` を調整
   - `.swift-version` で Swift バージョンを指定

### 🔧 ローカルでのテスト方法

```bash
# SwiftLintでコード品質をチェック
swiftlint

# SwiftFormatでフォーマットをチェック
swiftformat --lint .

# SwiftFormatで自動修正
swiftformat .

# Xcodeでビルドとテスト
xcodebuild -project github_action_swift.xcodeproj -scheme github_action_swift -destination 'platform=iOS Simulator,name=iPhone 15' build test
```

## 📚 参考リンク

- [GitHub Actions Documentation](https://docs.github.com/ja/actions)
- [SwiftLint](https://github.com/realm/SwiftLint)
- [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)

## 🎉 次のステップ

GitHub Actions に慣れたら、以下の機能も試してみてください：

- 🚀 App Store Connect への自動デプロイ
- 📱 TestFlight への自動アップロード
- 🔒 コードサイニングを自動化
- 📈 コードカバレッジの測定と報告
