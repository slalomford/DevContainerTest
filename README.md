# Dev Container for Quavo PoC

Prereqs:

  All environments:
    Install Docker Desktop
    Install VS Code
    Install Dev Containers VS Code extension (ms-vscode-remote.remote-containers)

  Windows:
    Install git for windows
    Enable OpenSSH Auth Agent
      Start > Services
      Find OpenSSH Authentication Agent
      Set Startup type to Automatic
      Click Start
    Install WSL2 with Ubuntu distrobution
    Enable WSL Integration in Docker Desktop
      Settings > Resources > WSL Integration

  Mac:
    Install Homebrew

All steps below should be done in WSL2 on windows

Setup SSH:
  ssh-keygen -t ed25519 -C "your@email.com"
    accept the default path
  cat ~/.ssh/id_ed25519.pub
    copy the output
  Add on bitbucket
    profile > personal settings > Security > SSH keys > add key > save
  Add to sshh agent
    ssh-add ~/.ssh/id_ed25519
  If on windows, add the above step to your wsl shell profile
    nano ~/.bashrc
    Copy paste "ssh-add ~/.ssh/id_ed25519" to bottom of file

Setup AWS SSO
  Mac:
    brew install awscli
  Windows:
    sudo apt install unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip && sudo ./aws/install

  Configure the sso
    aws configure sso
      SSO session name (Recommended): Quavo
      SSO start URL [None]: https://d-906606380d.awsapps.com/start
      SSO region [None]: us-east-1
      SSO registration scopes [sso:account:access]:
      Using the role name "AdministratorAccess"
      Default client Region [None]: us-east-1
      CLI default output format (json if not specified) [None]: json
      Profile name [AdministratorAccess-437379002957]:

  in .devcontainer/devcontainer.json replace the line 
    "AWS_PROFILE": "your-sso-profile-name",
  to reflect the profile name you chose    
    
Setup AI secrets
  mkdir -p ~/.config/devcontainer-secrets
  touch ~/.config/devcontainer-secrets/.env

  open the file and add the API keys
    ANTHROPIC_API_KEY=sk-ant-...
    KIRO_API_KEY=...

  secure the file
    chmod 600 ~/.config/devcontainer-secrets/.env
  


