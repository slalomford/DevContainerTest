# Quavo PoC — Dev Container Setup

## Prerequisites

### All platforms

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/)
- VS Code extension: **Dev Containers** (`ms-vscode-remote.remote-containers`)

### Windows only

- [Git for Windows](https://git-scm.com/download/win)
- Enable the OpenSSH Authentication Agent service:
  1. Open **Start** → search for **Services**
  2. Find **OpenSSH Authentication Agent**
  3. Set startup type to **Automatic**
  4. Click **Start**
- Install WSL2 with the Ubuntu distribution:
  ```powershell
  wsl --install
  ```
  Restart your machine after this completes.
- In Docker Desktop: **Settings → Resources → WSL Integration** → enable your Ubuntu distro

### Mac only

- [Homebrew](https://brew.sh/):
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```

---

> **Windows users:** all steps below should be run in your WSL2 terminal unless stated otherwise.

---

## Step 1 — Set up SSH and Git

Generate an SSH key:

```bash
ssh-keygen -t ed25519 -C "your@email.com"
# Accept the default path when prompted
```

Copy your public key and add it to Bitbucket:

```bash
cat ~/.ssh/id_ed25519.pub
# Copy the output
```

In Bitbucket: **Profile → Personal settings → Security → SSH keys → Add key → Save**

Add the key to your SSH agent:

```bash
ssh-add ~/.ssh/id_ed25519
```

**Windows only** — make the SSH agent persist across WSL2 sessions by adding this to your `~/.bashrc`:

```bash
nano ~/.bashrc
```

Paste at the bottom:

```bash
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi
```

Set up your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## Step 2 — Set up AWS SSO

Install the AWS CLI:

**Mac:**

```bash
brew install awscli
```

**Windows (WSL2):**

```bash
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install
```

Configure SSO:

```bash
aws configure sso
```

Enter the following values when prompted:

| Prompt                    | Value                                    |
| ------------------------- | ---------------------------------------- |
| SSO session name          | `Quavo`                                  |
| SSO start URL             | `https://d-906606380d.awsapps.com/start` |
| SSO region                | `us-east-1`                              |
| SSO registration scopes   | _(press Enter to accept default)_        |
| Role name                 | `AdministratorAccess`                    |
| Default client region     | `us-east-1`                              |
| CLI default output format | `json`                                   |
| Profile name              | `dev`                                    |

Then update `.devcontainer/devcontainer.json` — find this line:

```json
"AWS_PROFILE": "your-sso-profile-name",
```

And replace it with:

```json
"AWS_PROFILE": "dev",
```

---

## Step 3 — Set up AI secrets

Create the secrets file:

```bash
mkdir -p ~/.config/devcontainer-secrets
touch ~/.config/devcontainer-secrets/.env
```

Open the file and add your API keys:

```bash
nano ~/.config/devcontainer-secrets/.env
```

```
ANTHROPIC_API_KEY=sk-ant-...
KIRO_API_KEY=...
```

Secure the file:

```bash
chmod 600 ~/.config/devcontainer-secrets/.env
```

---

## Step 4 — Open the dev container

1. Make sure **Docker Desktop is running**
2. Open the repo folder in VS Code
3. When prompted, click **Reopen in Container** — or open the Command Palette (`Ctrl/Cmd+Shift+P`) → **Dev Containers: Reopen in Container**
4. The first build takes 5–10 minutes. Subsequent opens take ~15 seconds.
5. You'll know it's ready when the bottom-left of VS Code shows **Dev Container: Quavo PoC**

---

## Daily workflow

Ensure Docker Desktop is running, then open VS Code as normal. If your AWS token has expired (tokens last 8 hours), refresh it with:

```bash
aws sso login
```

That's it — SSH, Git, and your API keys are loaded automatically.
