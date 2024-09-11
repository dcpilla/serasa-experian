from flask import Flask
import os
import time
import logging

app = Flask('DEMO WebServer')

logging.basicConfig(level=logging.INFO)

msg = os.environ.get('MSG', 'Default Message')
countStart = os.environ.get('COUNT_START', 0)
count = int(countStart)
fullMsg = msg

def printMsg():
    global count, fullMsg
    fullMsg = msg + ' #' + str(count)
    app.logger.info('Message = %s', fullMsg)

# -- WebServer

@app.route("/")
def get_info():
    return "Hello World!\n"

@app.route("/up")
def up_print():
    global count
    count += 1
    printMsg()
    return "Count increased.\n"

@app.route("/show")
def get_msg():
    return fullMsg + "\n"

@app.route("/down")
def down_print():
    global count
    count -= 1
    printMsg()
    return "Count decreased.\n"


