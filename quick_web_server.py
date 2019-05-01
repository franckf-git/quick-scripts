#! /usr/bin/python3

# import des modules
import http.server
import socketserver
import os
import sys

# le port du serveur web
port = 8000

# le chemin du dossier serveur - a mettre en argument ?
#path = str(sys.argv[1])
path = "FOLDER/WEB"

# on se met dans le dossier serveur
web_dir = os.path.dirname(path)
os.chdir(web_dir)

# on lance le serveur python
Handler = http.server.SimpleHTTPRequestHandler
httpd = socketserver.TCPServer(("", port), Handler)
print("serving at port", port)
print("serving at folder", web_dir)
httpd.serve_forever()
