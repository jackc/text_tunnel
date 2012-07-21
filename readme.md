# Text Tunnel

Text Tunnel is a tool to edit remote files with a local editor.

## How It Works

The text_tunneld server runs on the local host. Using SSH, a reverse port
forward is established on the remote host connecting back to the server. The
text_tunnel client runs on the remote machine and is used as the editor
binary. When the client is told to edit a file it sends the file to the
server, and the server loads it in the local editor. The client polls the
server for changes and downloads them whenever they occur.

## Installation

The text_tunnel gem needs to be installed on both the local and remote hosts.

    gem install text_tunnel

## Usage

Start the server on the local machine. If you don't have an EDITOR environment
variable set you will need to include an --editor option.

    text_tunneld -e /usr/local/bin/subl

Connect to the remote host with SSH and specify a reverse port forward (the
default port for Text Tunnel is 1777).

	ssh -R 1777:localhost:1777 remote-host

On the remote machine use text_tunnel as your editor.

	text_tunnel /path/to/file

The file should open on your local machine. Do your edits and save your file.
It will automatically be transferred to the remote host. When you are done hit
Crtl+C on the remote host to terminate Text Tunnel.

## Shortcuts

The reverse port forward can be configured in ~/.ssh/config to avoid having to
retype the reverse port forward on the command line every time.

Consider setting text_tunnel as your EDITOR environment variable on your
remote hosts. This will let you use a local text editor for git commit
messages, crontabs, etc.
