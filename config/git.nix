{ config, pkgs, ... }:

{
  environment = 
    let
      git_minimal = ((pkgs.git.overrideAttrs (oldAttrs: rec { doInstallCheck = false; })).override {
        guiSupport = false;
        pythonSupport = false;
        perlSupport = false;
        withManual = false;
        withLibsecret = true;
      });
    in
    {
      systemPackages = [ (git_minimal) ];
      etc.gitconfig = if config.services.xserver.enable then
      {
        text = ''
[credential]
  helper = ${git_minimal}/bin/git-credential-libsecret
[core]
  filemode = true
  autocrlf = false
[push]
  default = current
[help]
  autocorrect = 30
[merge]
  tool = vimdiff
  conflictstyle = diff3
[mergetool]
  prompt = false
  keepBackup = false
[difftool]
  prompt = false
[color]
  ui = auto
[color "grep"]
  separator = green
  filename = magenta bold
  linenumber = magenta
[color "diff"]
  commit = magenta
  meta = cyan bold
  frag = magenta bold
  old = red
  new = green
[color "branch"]
  remote = red
  current = yellow
  local = red bold
[color "status"]
  added = yellow
  changed = red bold
  untracked = red
  header = cyan bold
  branch = yellow

        '';
      } else {
        text = "";
      };
    };
}

