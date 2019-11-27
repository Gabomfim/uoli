from http.server import HTTPServer, BaseHTTPRequestHandler
from threading import Timer
from io import BytesIO
from sys import stdin, stdout, stderr
import os

def exit_bridge():
  os._exit(0)

DEBUG_ENABLED = False

def err_print(m):
  if(not DEBUG_ENABLED):
    return
  stderr.write(m)
  stderr.flush()

def putDebugChar(c):
  stdout.write(c)

def getDebugChar(n=1):
  return stdin.read(n)

def readFromGDB():
  data = ""
  ch = ' '

  while 1:
    while ch != '$':
      ch = getDebugChar()

    sum = 0 # checksum
    while 1:
      ch = getDebugChar()
      if (ch == '$' or ch == '#'):
        break
      sum += ord(ch)
      data += ch

    if (ch == '$'):
      continue

    if (ch == '#'):
      pacSum = int(getDebugChar(n=2), base=16)

      if (sum&0xFF != pacSum):
        putDebugChar('-') # Signal failed reception.
        stdout.flush()
        stderr.write("Signal failed reception. %d !=  %d\n" % (sum&0xFF, pacSum))
        stderr.write()

      else:
        putDebugChar('+') # Signal successul reception.
        stdout.flush()
        # If sequence char present, reply with sequence id.
        if (len(data) >= 3 and data[2] == ':'):
          putDebugChar(data[0])
          putDebugChar(data[1])
          stdout.flush()
          data = data[3:]
        return data
  return data

def writeToGDB(data):
  while 1:
    putDebugChar('$')
    checksum = 0x1000000
    for c in data:
      putDebugChar(c)
      checksum += ord(c)

    putDebugChar('#')
    putDebugChar(hex(checksum)[-2:])
    stdout.flush()
  
    c = getDebugChar()
    if (c == '+'):
      return


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

  def do_GET(self):
    self.send_response(200)
    self.send_header("Access-Control-Allow-Origin", "*")
    self.send_header('Content-type','text/html')
    self.end_headers()
    err_print("[BRIDGE DEBUG] Reading from GDB\n")
    res = readFromGDB()
    self.wfile.write(bytes(res, "utf-8"))
    err_print("[BRIDGE DEBUG] Sent: " + str(res) + '\n')
    if(res[0] == "k" or (res[0] == "v" and "vKill;" in res)):
      err_print("[BRIDGE DEBUG] Killing bridge in 3 seconds...\n")
      t = Timer(3.0, exit_bridge)
      t.start()

  def do_POST(self):
    content_length = int(self.headers['Content-Length'])
    body = self.rfile.read(content_length)
    self.send_response(200)
    self.send_header("Access-Control-Allow-Origin", "*")
    self.send_header('Content-type','text/html')
    self.end_headers()
    err_print("[BRIDGE DEBUG] Writing to GDB\n")
    writeToGDB(body.decode("utf-8"))
    err_print("[BRIDGE DEBUG] Received: " + body.decode("utf-8") + '\n')
    # response = BytesIO()
    # response.write(b'Written to GDB: ')
    # response.write(body)
    # self.wfile.write(response.getvalue())

  def log_message(self, format, *args):
    return


httpd = HTTPServer(('localhost', 5689), SimpleHTTPRequestHandler)
httpd.serve_forever()