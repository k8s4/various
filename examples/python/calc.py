from colorama import init
from colorama import Fore, Back, Style

init()

def calc(a, b, use):
  if use == "+":
    return a + b
  elif use == "-":
    return a - b
  elif use == "*":
    return a * b
  elif use == "/":
    return a / b
  else:
    return "N/A"

def main():
  print(Fore.RED)
  use = input("Use \"+\", \"-\", \"*\", \"/\", \"q\":")
  if use == "q":
    exit()
  print(Fore.GREEN)
  a = int(input("Enter first number: "))
  b = int(input("Enter second number: "))

  print(Fore.YELLOW)
  print("Result: ", calc(a, b, use))

while 1:
  main()
