# Atomy Toolkit

English | [한국어](README.ko.md)

**A toolkit so you don't have to explain everything to your AI from scratch every time.**

If you use AI coding tools like Claude Code, you know the pattern. You explain the same
decision again today. The AI says "done!" and the thing doesn't actually run. You open a
new chat and all the context you built up is gone.

Install Atomy Toolkit into a project once, and:

- **The AI remembers what you did yesterday** — what you decided and why gets written down, and it gets picked up automatically in the next conversation.
- **"Done" needs proof** — a rule blocks the AI from claiming completion until it has actually run the tests and shown you the output.
- **Work follows an order** — research, then a plan, then your approval, then code. You get a chance to say "no, not that" while it's still a plan.
- **Everything stays on your machine** — nothing is sent to a server.

> 💡 **Who is this for?**
> It's built for people who don't write code themselves but want to build something with
> AI and hand it to a developer later. Developers will find it useful too.

---

## Current version

- Latest public release: **[v0.4.4](https://github.com/suhwang-atomy/_global-toolkit-releases/releases/tag/v0.4.4)** (2026-08-03)
- The additions after `v0.4.0` are summarized below. For the full `v0.4.0` baseline, see the [English patch notes](PATCH_NOTES.md) or [한국어](PATCH_NOTES.ko.md).

This repository holds the installers and the docs only. The program's source code is private.

---

## Install

### First, check what you need

You need **Python 3.12 or newer**. Open a terminal (PowerShell on Windows) and run:

```bash
python3 --version
```

If you see something like `Python 3.12.x`, you're ready. If it says the command isn't
found, or the number is lower than 3.12, install it from
[python.org](https://www.python.org/downloads/) first.

> The installer will not install Python for you. If it's missing, it stops and tells you
> where to get it. (If you already have `uv`, that works too.)

### Install commands

**Copy and paste the whole block.** All three lines are one set.

<!-- markdownlint-disable MD013 -->

**Windows (PowerShell)**

```powershell
Invoke-WebRequest -Uri https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.4/install-cli.ps1 -OutFile install-cli.ps1
$expected = "e107934e55a7799a49b4769f1602aba0e831af18dba2e9410d5f02e06e0240b9"
$actual = (Get-FileHash .\install-cli.ps1 -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actual -ne $expected) { throw "Installer SHA256 mismatch" }
& .\install-cli.ps1
```

**macOS**

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.4/install-cli.sh
echo "6a79a6bfb73a73c6ee4d9f9d8e12ec0d0cecf6a64b845275b36ac2b524bc7e99  install-cli.sh" | shasum -a 256 -c -
sh install-cli.sh
```

**Linux**

```bash
curl -fL -o install-cli.sh https://github.com/suhwang-atomy/_global-toolkit-releases/releases/download/v0.4.4/install-cli.sh
echo "6a79a6bfb73a73c6ee4d9f9d8e12ec0d0cecf6a64b845275b36ac2b524bc7e99  install-cli.sh" | sha256sum -c -
sh install-cli.sh
```

<!-- markdownlint-enable MD013 -->

<details>
<summary><b>What is that long string in the middle?</b> (click to expand)</summary>

The middle line **checks that the file you downloaded is really the file we published.**
Every file has a fingerprint (its SHA256). If the fingerprint doesn't match the one we
published, someone swapped the file along the way, and the install stops.

That's why this is split into three steps — **① save the file → ② check the fingerprint →
③ run it** — instead of piping a download straight into a shell. A one-liner is shorter,
but it skips this check.

If the fingerprint doesn't match, don't install it. Tell us instead.

</details>

### What happens when it installs

The program goes into **its own separate space**, away from everything else. It does not
touch the Python setup already on your computer.

Check that it worked:

```bash
atomy-toolkit --version
```

Have it check itself for problems:

```bash
atomy-toolkit doctor
```

### Try your first project

```bash
atomy-toolkit install ./my-project
```

This creates the rules and the memory space your AI will use inside the `my-project`
folder. Then open Claude Code in that folder and type `/rpi`. In Codex, type `$rpi`
instead. It walks through research, plan, and build, in that order.

For more install options see [INSTALL.md](INSTALL.md). For the full verification procedure
see the [public install guide](docs/reference/PUBLIC_RELEASE_INSTALL_GUIDE.md).

---

## What's better in v0.4.4

Every feature is labeled with **how far it has actually been proven**.

| Label | What it means |
|---|---|
| ✅ **Verified** | It passed its tests. Go ahead and use it. |
| 🟡 **Preview** | It has been used for real, but it's still being refined. Keep an eye on it. |
| 🧪 **Experimental** | Not yet used for real work. Don't rely on it for anything important. |

### ✅ Updating the Toolkit now updates the projects it knows

When you install a newer Toolkit version, it now refreshes the Toolkit files in projects
you have already connected. You no longer need to update Cascade first or run a separate
command for every project. Your own edits are kept, and a backup is made before a managed
file changes.

The Toolkit only checks projects it has recorded on this computer. It does not search your
whole disk, and the list is never sent to a server. Projects made with `/new` or
`atomy-toolkit install` are recorded automatically.

If you brought the Toolkit into an existing project by asking an AI to copy it, record that
project once:

```bash
atomy-toolkit adopt ./my-existing-project
atomy-toolkit projects list
```

`adopt` records the project and brings its Toolkit files up to date. On Windows, v0.4.4
also fixes the command path during installation, so `atomy-toolkit` works in a new terminal.

### ✅ Keep the product guide beside the product (Claude Code: `/plandoc`, Codex: `$plandoc`)

`plandoc` creates and maintains a set of plain-language product documents: what the
product should do, which screens exist, how people move through them, what data it uses,
and what the next person needs to know. It compares those documents with the code and the
existing plan, so missing or outdated parts are easier to spot.

Since v0.4.3, Codex receives `plandoc` as a proper skill. Type `$plandoc` in Codex, not
`/prompts:plandoc`. After installing or updating, restart Codex or open a new conversation
so the new skill appears. The Toolkit can gather the facts, but it still asks a person to
decide what the product *should* become when the code and the written plan disagree.

### 🟡 Coordinate several workers without losing the plan (`/pm`)

Claude Code can turn an approved plan into separate work cards, track those cards as
GitHub issues, and collect the resulting pull requests for one final decision. This is
useful when several independent jobs can run at the same time.

`/pm` is currently a Claude Code preview. It does not remove the human review step or give
workers permission to change an important branch on their own.

### ✅ Keep explanations consistent across AI tools

The Toolkit now keeps the chosen explanation level in one project setting and carries it
across Claude Code, Codex, Cursor, and Antigravity instructions. It can also suggest a
simpler level when repeated prompts show that the current explanations are too technical.

### ✅ Updating no longer wipes the files you edited

Updating the toolkit used to risk resetting your own edits back to the defaults. Now it
**tells the difference between a file as the toolkit shipped it and a file you changed**,
and leaves your changes alone. Before writing anything it shows you "here's what I'm about
to change", and for files it skips it tells you why.

> ⚠️ **What it still can't do** — it can't **automatically merge** your edits with a new
> version (it picks one or the other). There's also no "undo" button after an update
> finishes. To roll back, copy from the backup folder it created for you.

### ✅ "Done" now comes with evidence

When the AI says a task is finished, it ties together **what changed and whether the tests
actually passed**. Work that hasn't passed review doesn't get marked complete.

### ✅ Context survives a new conversation

What you decided, what's half-finished, and what to watch out for get written down and
pulled back in automatically next time. Old notes get tidied up, but **anything still in
progress is never deleted.**

### ✅ See your project's shape as a report

You get a view of how code and decisions connect. It opens as a single file, with no
internet connection required.

### ✅ Your usage stays on your machine

Nothing is sent to a server. You choose whether to record usage at all, and even when it's
on, **what you typed, your file paths, and your project names are never stored.**

### 🟡 Let it work overnight (`/delegate`)

This runs on **your own computer**, the one you left on when you went home. It is not a
server feature. You seal off what it's allowed to do ahead of time, it only works inside an
isolated workspace, and in the morning a human decides `GO` or `NO-GO`.
**We have run a full night end to end.**

### 🟡 Other preview features

- **Automatic team-rule checks** — we ran the experiment of checking the same rules with two different AI tools, but multi-person use hasn't been tested yet.
- **Sharing memory across machines** — verified over a local network. The machine used for the test was just another PC that happened to be free, not a production server.
- **Away-from-desk batches / research relay** — built with the safety rails in place, but the actual scheduled runs haven't happened yet.

### 🧪 Experimental

- **Antigravity and Cowork integration** — installs fine, but needs more real-world use.
- **Automatic feature promotion** — off by default.

---

## What this toolkit does not do

Things you shouldn't expect, written down up front.

- **`atomy-toolkit update` is not the installer.** Use the versioned installer above to update the Toolkit. v0.4.4 then refreshes recorded projects automatically; `atomy-toolkit cascade sync` is still available when you want to refresh one project by hand.
- **It won't merge code on its own, write to your important branches, or deploy to a live service.**
- **It doesn't send usage data to the cloud.** Everything runs on your machine.
- **There's no service that processes your records on a server for you.** That's a separate idea still under consideration, and it isn't part of v0.4.4.

---

## Everyday commands

```bash
atomy-toolkit --version              # check the version
atomy-toolkit doctor                 # self-diagnose problems
atomy-toolkit install ./my-project   # set up a project
atomy-toolkit adopt ./old-project    # connect an existing project
atomy-toolkit projects list          # show connected projects
atomy-toolkit memtemple --help       # memory store
atomy-toolkit graph --help           # see your project's shape
```

---

<details>
<summary><b>Technical details</b> — file fingerprints, version scheme (click to expand)</summary>

### Release assets and integrity

The v0.4.4 GitHub Release has exactly four assets.

| Asset | SHA256 |
|---|---|
| `atomy_toolkit_lib-0.4.4-py3-none-any.whl` | `e864ed8d2e0d258452b8bc7fae26cfd37a9fd00355f5970c3f06ee8e696ffb90` |
| `SHA256.txt` | `fb58b9f993078161bb775195881add8104e4678a2b8438baaa291eeddff48624` |
| `install-cli.sh` | `6a79a6bfb73a73c6ee4d9f9d8e12ec0d0cecf6a64b845275b36ac2b524bc7e99` |
| `install-cli.ps1` | `e107934e55a7799a49b4769f1602aba0e831af18dba2e9410d5f02e06e0240b9` |

`SHA256.txt` contains the hashes for the wheel and the two command installers. A checksum
file cannot contain a stable hash of itself, so the hash for `SHA256.txt` is listed
separately in the table above.

The assets are not signed. The pinned hashes above are the release integrity control.
`.exe`, `.pkg`, `.dmg`, and `.AppImage` are not part of the official v0.4.4 distribution.

The bootstrap downloads only the pinned `atomy_toolkit_lib-0.4.4-py3-none-any.whl` and
verifies its embedded SHA256. It then installs into an isolated virtual environment and
runs `atomy-toolkit self-install`. It never installs into system site-packages.

- release-preparation commit: `65f33d6ecd84aaa4c6bdfbadcd351fe654ca5fb0`
- Graph Report pins Playwright `1.62.0` as a direct development dependency. Playwright is
  not included in the runtime wheel.

### Version scheme

A GitHub tag like `v0.4.4` is a public product release. The historical cascade metadata
value `1.0.0` belongs to a separate internal asset version lineage and does not mean a
public `v1.0.0` release. The cascade master metadata in this wheel is `1.1.7`.

</details>

---

## License and privacy

Atomy Toolkit v0.4.4 is distributed under the [MIT License](LICENSE). [NOTICE](NOTICE) and
the [Graph Report third-party notices](THIRD_PARTY_NOTICES.md) credit the outside material
we used.

This public repository does not contain the private source tree. Packaging excludes
development history, credentials, local memory, session and log state, backups, and
in-progress project documents.
