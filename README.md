# obsidian-claude-skills

Claude Code 用の Obsidian 連携スラッシュコマンド集。
**「3年後の自分にも価値がある知識」だけを Obsidian に資産化する** ことを目的に、日々の開発から学びを抽出して蓄積するワークフローを提供する。

## 提供するスキル

| コマンド | 用途 |
|---|---|
| [`/log-learning`](commands/log-learning.md) | 現在の作業から CS基礎・フレームワーク・設計パターンの学びを Obsidian に記録する |
| [`/log-from-pr`](commands/log-from-pr.md) | 他人のPR・イシューから学びを抽出して Obsidian に記録する（レビュー指摘は金脈） |
| [`/log-from-article`](commands/log-from-article.md) | 外部記事・発表資料・書籍などの URL を渡すと内容を咀嚼して Obsidian に記録する |

3 スキルは独立して使えるが、出力先の Vault 構造を共有しており、組み合わせると **Zettelkasten 的な知識ベース** が育つ設計になっている。

## 想定する Obsidian Vault 構造

```
obsidian-vault/
├── 00_Inbox/                # イシュー紐付けできない記録
├── 10_Issues/               # 作業記録（<ISSUE-ID>.md）
├── 20_Knowledge/            # 学びの蓄積（技術ドメイン別）★主役
│   ├── 01_フロントエンド/
│   ├── 02_バックエンド/
│   ├── 03_データベース/
│   ├── 04_インフラ/
│   ├── 05_開発ツール/
│   ├── 06_AI駆動開発/
│   ├── 07_アーキテクチャ/
│   └── 08_CS基礎・Web開発/
├── 40_Articles/             # 外部記事 (Literature Notes)
└── 90_Templates/            # issue.md / note.md / issue-observation.md
```

各スキルは デフォルトで `~/obsidian-vault/` を参照する。別の場所を使う場合は、各 `commands/*.md` 内の Vault パスを書き換える。

## 設計思想

- **3年後の自分・別プロジェクト・別言語でも使えるか?** を判断軸に、ライブラリ固有の罠は記録しない
- **作業記録 (10_Issues) は軽量に**、概念は **知識ノート (20_Knowledge)** に切り出して `[[Wiki link]]` で結ぶ
- **Literature Notes (40_Articles)** は記事の独自用語を普通の日本語に言い換える / 鵜呑みを防ぐ批判的読解を残す
- 既存ノートとの整合性チェック・未定義リンク検出を組み込み、**学びの連鎖** を起こす

## インストール

### 1. クローン

```bash
git clone https://github.com/iakito-dev/obsidian-claude-skills.git ~/dev/obsidian-claude-skills
```

### 2. スラッシュコマンドとして登録

User-scoped（全プロジェクトで使用可能）にする場合:

```bash
ln -s ~/dev/obsidian-claude-skills/commands/log-learning.md     ~/.claude/commands/log-learning.md
ln -s ~/dev/obsidian-claude-skills/commands/log-from-pr.md      ~/.claude/commands/log-from-pr.md
ln -s ~/dev/obsidian-claude-skills/commands/log-from-article.md ~/.claude/commands/log-from-article.md
```

Project-scoped にする場合は、プロジェクトの `.claude/commands/` 配下に同じ symlink を張る。

### 3. Vault を用意

`~/obsidian-vault/` を作成し、Obsidian で開く。上記のディレクトリ構造で運用する。
スキル側は **既存ファイルを Read してから Edit** する設計なので、最初は空の Vault でも動く。

### 4. 利用

```
/log-learning             # 現在の作業から学びを記録
/log-from-pr <PR URL>     # PR から学びを抽出
/log-from-article <URL>   # 外部記事を咀嚼して記録
```

## イシュー ID の形式について

スキルは `[A-Z]+-\d+` 形式のイシュー ID（例: `CFP-1066`, `PROJ-42`）を抽出するデフォルトを持つ。
別の形式を使うプロジェクトでは、各 `commands/*.md` 内の正規表現を書き換えれば対応できる。

## 関連

- [Claude Code Slash Commands](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Obsidian](https://obsidian.md/)
- [Zettelkasten](https://zettelkasten.de/)

## ライセンス

[MIT](LICENSE)
