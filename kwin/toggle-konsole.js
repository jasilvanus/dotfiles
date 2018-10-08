const curdesk = workspace.currentDesktop
var clients = workspace.clientList()
for (var i=0; i < clients.length; i++) {
   c = clients[i]
   if (c.desktop == curdesk && c.caption.search("Konsole") != -1) {
	  if (workspace.activeClient == c) {
         c.minimized = true
	  } else {
         workspace.activeClient = c
	  }
   }
}

