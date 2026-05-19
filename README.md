# obsidian-claude-skills

Claude Code 用の Obsidian 連携スラッシュコマンド集。

| コマンド | 用途 |
|---|---|
| [`/log-learning`](commands/log-learning.md) | 現在の作業から学びを Obsidian に記録する |
| [`/log-from-pr`](commands/log-from-pr.md) | 他人のPR・イシューから学びを抽出して記録する |
| [`/log-from-article`](commands/log-from-article.md) | 外部記事・発表資料などのURLを咀嚼して記録する |

## インストール

### 1. クローン

```bash
git clone https://github.com/iakito-dev/obsidian-claude-skills.git ~/dev/obsidian-claude-skills
```

### 2. スラッシュコマンドとして登録

User-scoped（全プロジェクトで使用可能）:

```bash
ln -s ~/dev/obsidian-claude-skills/commands/log-learning.md     ~/.claude/commands/log-learning.md
ln -s ~/dev/obsidian-claude-skills/commands/log-from-pr.md      ~/.claude/commands/log-from-pr.md
ln -s ~/dev/obsidian-claude-skills/commands/log-from-article.md ~/.claude/commands/log-from-article.md
```

Project-scoped にする場合は、プロジェクトの `.claude/commands/` 配下に同じ symlink を張る。

### 3. Vault を用意

各スキルはデフォルトで `~/obsidian-vault/` を参照する。別の場所を使う場合は `commands/*.md` 内の Vault パスを書き換える。

## ライセンス

[MIT](LICENSE)
