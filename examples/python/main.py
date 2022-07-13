def func_vars():
  var_int = 1
  var_float = 1.4
  var_string = "foo"
  var_bool = True
  # print(input("Enter smthng: "))
  print(type(var_bool))
  print(str(var_float))

def func_for():
	print("Test for")
	for i in range(0, 5):
		if i == 2:
			pass
		elif i == 3:
			print("xoxo")
		else: 
			print(i)

def func_while():
	print("Test while.")
	i = 0
	while i < 3:
		print (i)
		i = i + 1

def func_case():
	pass

func_vars()
func_for()
func_while()
func_case()




