---
description: 日本語の文章を textlint（技術ライティング + AI生成検出プリセット）で校正する
---

# check-ja

日本語の Markdown / プレーンテキストを **textlint** で校正するスキル。
2 つのプリセットで「技術文章として不自然な箇所」と「AI が書いた感じが残っている箇所」を検出する。

- [textlint-rule-preset-ja-technical-writing](https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing)
  — 一文の長さ、助詞の連続、ら抜き、二重否定、冗長表現など
- [textlint-rule-preset-ai-writing](https://github.com/textlint-ja/textlint-rule-preset-ai-writing)
  — リストの機械的書式、絵文字濫用、誇張表現、強調パターン、コロン後にブロックが続く構文など

## 入力

- 校正したいファイルのパス（複数可）
- `--fix` フラグ（自動修正したい場合）
- 範囲指定（行番号、セクション名 — オプション）

例:
- `/check-ja path/to/file.md`
- `/check-ja --fix path/to/file.md`
- `/check-ja` （引数なしの場合は対象を確認）

## 動作

### 1. 対象ファイルの特定
- 引数があればそれを使う
- 無ければ「直前の会話で生成した／編集したファイルでよいか」と確認
- 複数ファイルもまとめて指定可能

### 2. textlint 実行

ラッパースクリプトを使う:

```bash
/Users/iakito/dev/obsidian-claude-skills/tools/textlint/run.sh <file>
```

- 初回実行時は自動で `npm install` が走る
- Node 18+ が必要だが、ラッパーが nvm 経由で適切なバージョンを選ぶ
- `--fix` で自動修正可能なルールは直す

### 3. 結果の整理と提示

textlint の出力は素のままだと冗長なので、Claude 側で整理する:

- **ファイルごと**にまとめる
- **ルール別件数**を最初にサマリで提示（例: `no-doubled-joshi: 8 件 / no-ai-list-formatting: 6 件`）
- **代表例を 3〜5 件**抜粋（同種が大量にあれば全部見せない）
- 自動修正できないルール（文体・構成系）は **人間判断が必要**なので「どう直すか」の案を 1〜2 個提案

### 4. 修正の提案 → 適用

- 機械的に直せるもの（句読点、二重否定、ら抜き等）は `--fix` 後の差分を見せて承認
- 文体・構成系は「ここをこう書き換えると指摘が消える」案を提示し、ユーザー確認後に Edit で適用
- 「指摘は出るが意図的にそう書いている」場合はその旨を確認して飛ばす

### 5. 設定ファイル

`/Users/iakito/dev/obsidian-claude-skills/tools/textlint/.textlintrc.json` に有効ルールが定義されている。
プロジェクトごとに緩めたいルールがある場合はこのファイルを編集する。

現在の設定（抜粋）:
- `sentence-length: max 120` — 一文 120 文字以内（プリセット標準は 100 だが、技術文書なので少し緩めている）
- `no-exclamation-question-mark: false` — 感嘆符 `!` を許容
- それ以外はプリセットのデフォルト

## 出力フォーマット例

```
## 校正結果: foo.md

検出: 23 件 (3 ファイル中、修正可能: 4 件)

### ルール別件数
- no-doubled-joshi (助詞の連続): 8 件
- no-ai-list-formatting (リストの機械的書式): 6 件
- sentence-length (一文が長すぎる): 3 件
- ja-no-redundant-expression (冗長表現): 4 件
- no-double-negative-ja (二重否定): 2 件

### 代表的な指摘
- L22:31 — 「〜か〜か」と "か" が一文内で 2 回出ています
  - 修正案: 「〜のか、〜か」のように接続を変える
- L24:1 — `**重要**:` の書き方はAIっぽい。本文化を推奨
  - 修正案: 「重要なのは〜」と文章に書き換え
- L43 — 一文 123 文字。3 文字オーバー
  - 修正案: 「〜です。一方で〜」で 2 文に分割

### 自動修正したいもの
[1] no-double-negative-ja 2 件 — 直しますか?
[2] ja-no-weak-phrase 1 件 — 直しますか?

→ ユーザー確認後に Edit で適用
```

## 記録しないもの
- 校正結果そのものは Obsidian に残さない（一時的なフィードバック）
- 既存ノートに「textlint 通過済み」のような印もつけない

## トリガー
ユーザーが明示的に `/check-ja` を呼んだときのみ動作。
他スキル（log-from-*, pr 等）からは自動連携しない。
