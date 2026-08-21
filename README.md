# dotfiles

## 必要なもの

- [rcm](https://github.com/thoughtbot/rcm) — `brew install rcm`
- git
- 推奨: `ghq`, `jq`, `direnv`, `gh`（Claude Code 関連のヘルパが使う）

## 新規マシンのセットアップ

```sh
# 1. clone
ghq get github.com/mactkg/dotfiles   # あるいは git clone ... ~/.dotfiles

# 2. $HOME に symlink を貼る（rcm は .rcrc で excludes / undotted を読む）
RCRC=~/.dotfiles/rcrc rcup

# 3. symlink しないファイルを seed（~/.secrets, ~/.gitconfig.local）
sh ~/.dotfiles/hooks/post-up

# 4. （任意）このマシン固有の値を上書き
$EDITOR ~/.gitconfig.local   # 別 identity / 別 signing key / maintenance path が必要な場合のみ
$EDITOR ~/.secrets           # API token など
```

手動作業は step 3-4 だけ。`rcup` は冪等、`post-up` も既存ファイルは触りません。デフォルトでは dotfiles gitconfig 側の `[user] = mactkg` が効くので、この identity で問題なければ step 4 は不要です。

## どこに何があるか

| 場所 | 用途 |
|---|---|
| `~/.dotfiles/`（tracked） | machine-neutral な設定。公開して問題ない内容だけ |
| `~/.gitconfig.local`（untracked, chmod 600） | opt-in の per-machine override（`[user]`, `[gpg "ssh"]`, `[maintenance]`）。`gitconfig.local.sample` から seed される。空でも動く |
| `~/.secrets`（untracked） | API token 等の shell env。`secrets` から seed される |
| `~/.gitconfig.secrets`（optional, untracked） | 追加の git config secrets が必要な場合 |

## マシン固有の git 設定（`~/.gitconfig.local`）

dotfiles の `gitconfig` は **`[user]` は mactkg デフォルトのみ** 持ち、絶対パスや signing binary、work email は一切含みません。work identity や別の signing key、maintenance 対象 repo などマシンごとに違うものは `~/.gitconfig.local` に書きます。このファイルは `~/.gitconfig` の末尾で include されるので、上の全定義に勝ちます:

```ini
[include]
	path = ~/.gitconfig.secrets
	path = ~/.gitconfig.local
```

これによる帰結:

- **新規マシン**: そのまま `mactkg <mactkg@gmail.com>` で commit できる。`post-up` は全部コメントアウトされた template を seed するので、編集しなければデフォルトが効くだけ
- **公開 dotfiles safe**: work email、signing binary の絶対パス、maintenance の絶対 repo path が upstream に漏れない
- **ディレクトリ別 identity**: `~/.gitconfig.local` の中で `[includeIf "gitdir:~/work/**"]` を使えば、特定ツリー配下でだけ identity 切り替えができる

## Claude Code 統合

`~/.dotfiles/claude/` に [Claude Code](https://claude.ai/code) 用の設定・hook・ヘルパをまとめています:

| ファイル | symlink 先 | 用途 |
|---|---|---|
| `claude/settings.json` | `~/.claude/settings.json` | グローバル設定。marketplace は inline `settings` source で commit SHA pin |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | グローバル assistant instruction |
| `claude/RTK.md` | `~/.claude/RTK.md` | CLAUDE.md から `@RTK.md` で参照される補助ドキュメント |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | status line renderer |
| `claude/hooks/worktree-gtr.sh` | `~/.claude/hooks/worktree-gtr.sh` | `WorktreeCreate` / `WorktreeRemove` hook。`git gtr` の薄い wrapper。プロジェクト固有の後処理（例: sa-nu/2h の `direnv allow apps/webapp`）はそのリポの local `gtr.hook.postcreate` 側に置くこと |
| `local/bin/claude-plugin-refresh.sh` | `~/local/bin/claude-plugin-refresh.sh` | pin 済み marketplace plugin の SHA を upstream HEAD と比較・書き換え |

### SHA pin された marketplace

`settings.json` の各サードパーティ plugin は inline (`"source": "settings"`) marketplace として宣言し、commit SHA で pin してあります。upstream の tag が動いても勝手に更新されない・prompt injection 経路になりにくい、というのが狙い。

SHA を更新するときは:

```sh
claude-plugin-refresh.sh              # pin 済み SHA と upstream HEAD を一覧
claude-plugin-refresh.sh --write crit # crit の SHA を書き換え、git diff を表示
```

差分と upstream の変更内容（GitHub 上で）を目視レビューしてから commit してください。
