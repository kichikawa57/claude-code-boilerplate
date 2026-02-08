# Claude Code Boilerplate

Claude Code CLIの全機能（agents, skills, rules, hooks）をフル活用した開発最適化ボイラープレート。

## Quick Start

```bash
# 1. このリポジトリをクローン
git clone https://github.com/yourname/claude-code-boilerplate.git

# 2. 対象プロジェクトにセットアップ
./claude-code-boilerplate/init-claude.sh /path/to/your-project

# 3. プロジェクト情報を編集
cd /path/to/your-project
vim CLAUDE.md

# 4. Claude Codeを起動
claude
```

## 構成

```
.claude/
├── settings.json          # チーム共有設定（permissions, hooks）
├── settings.local.json    # 個人設定（.gitignore対象）
├── CLAUDE.md              # .claude内メモリ
│
├── agents/                # 専門家エージェント
│   ├── reviewer.md        #   コードレビュー
│   ├── architect.md       #   設計・アーキテクチャ
│   ├── test-writer.md     #   テスト作成
│   └── debugger.md        #   デバッグ
│
├── skills/                # スラッシュコマンド
│   ├── overview/          #   /overview - プロジェクト俯瞰
│   ├── gen/               #   /gen - コード生成
│   ├── add-test/          #   /add-test - テスト追加
│   ├── create-pr/         #   /create-pr - PR作成
│   ├── check/             #   /check - 品質チェック
│   ├── troubleshoot/      #   /troubleshoot - エラー解決
│   └── doc/               #   /doc - ドキュメント生成
│
├── rules/                 # 自動適用ルール
│   ├── code-style.md      #   コーディングスタイル
│   ├── git-workflow.md    #   Gitワークフロー
│   ├── testing.md         #   テスト規約
│   ├── security.md        #   セキュリティ
│   └── documentation.md   #   ドキュメント規約
│
└── hooks/                 # 自動実行スクリプト
    └── protect-files.sh   #   機密ファイル保護
```

## 機能詳細

### Agents（専門家エージェント）

Claudeが自動的にタスクを委譲する専門家エージェント。メインのコンテキストを消費しません。

| エージェント | 役割 | モデル |
|-------------|------|--------|
| `reviewer` | コードレビュー（OWASP、パフォーマンス、品質） | sonnet |
| `architect` | 設計・アーキテクチャ分析・技術選定 | opus |
| `test-writer` | テスト設計・実装・実行 | sonnet |
| `debugger` | 系統的デバッグ・根本原因分析 | opus |

**使い方**: 自然に依頼するだけで自動委譲されます。
```
「このPRをレビューして」→ reviewer
「認証機能の設計を考えて」→ architect
「このファイルのテストを書いて」→ test-writer
「このエラーの原因を調べて」→ debugger
```

### Skills（スラッシュコマンド）

| コマンド | 説明 | AI自動実行 |
|---------|------|:---:|
| `/overview` | プロジェクト全体の構造を把握 | ○ |
| `/gen [type] [name]` | 既存パターンに従ったコード生成 | ○ |
| `/add-test [file]` | テストの自動生成・実行 | ○ |
| `/create-pr` | PR作成 | ✗（明示実行のみ） |
| `/check` | lint/typecheck/test一括実行 | ○ |
| `/troubleshoot [error]` | エラー原因の特定・修正案 | ○ |
| `/doc [target]` | ドキュメント生成 | ○ |

### Rules（自動適用ルール）

セッション開始時に自動読み込み。関連ファイル操作時にコンテキストとして適用されます。

- **code-style.md**: コーディングスタイル（全ファイル）
- **git-workflow.md**: Gitワークフロー規約（全ファイル）
- **testing.md**: テスト規約（テストファイルのみ）
- **security.md**: セキュリティルール（全ファイル）
- **documentation.md**: ドキュメント規約（全ファイル）

### Hooks（自動実行）

| タイミング | 処理 |
|-----------|------|
| ファイル編集前 | 機密ファイル・ロックファイルの保護 |
| ファイル編集後 | Prettier自動フォーマット |
| コンパクト時 | リマインダー読み込み |

### Settings（権限設定）

- **allow**: パッケージマネージャーのrun系コマンド、git読み取り系
- **deny**: 危険なコマンド、機密ファイルの読み取り
- **ask**: git push、merge、npm publish等

## カスタマイズ

### 1. CLAUDE.md の編集
プロジェクト固有の情報を記入してください：
- プロジェクト名・概要
- 技術スタック
- 主要コマンド（dev, build, test, lint）
- プロジェクト構造

### 2. Rules の調整
`.claude/rules/` 内のファイルをプロジェクトの規約に合わせて編集してください。

### 3. Settings の調整
`.claude/settings.json` の permissions をプロジェクトに合わせて調整してください。

## License

MIT
