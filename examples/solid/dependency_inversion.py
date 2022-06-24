import sys
import time

class TerminalPrinter:
    def write(self, msg):
        sys.stderr.write(f"{msg}\n")

class FilePrinter:
    def write(self, msg):
        with open("log.txt", "a+", encoding="UTF8") as f:
            f.write(f"{msg}\n")

class Logger:
    def __init__(self):
        self.prefix = time.strftime("%y-%b-%d %H:%M:%S", time.localtime())

    def log(self, msg, notifier):
        notifier().write(f"{self.prefix} {msg}")

logger = Logger()
logger.log("Test log to terminal...", TerminalPrinter)
logger.log("Test log to file...", FilePrinter)

