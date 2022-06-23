import sys
import time

class Logger:
    def __init__(self):
        self.prefix = time.strftime("%Y-%b-%d %H:%M:%S", time.localtime())

    def log(self, message):
        sys.stderr.write(f"{self.prefix} --> {message}\n")

class CustomLogger(Logger):
    def __init__(self):
        super().__init__()
        self.prefix = time.strftime("%Y-%b-%d", time.localtime())

logger = Logger()
logger.log("Some error happened =)")

mylogger = CustomLogger()
mylogger.log("Today some shit happened!")

