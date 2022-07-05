# Thanks for Alexey Goloburdin
# Some tests
# Limit of recursion in cpython = 1000

def chain_sum0(first):
    result = first
    def wrapper(second=None):
        nonlocal result
        if second is None:
            return result
        result += second
        return wrapper
    return wrapper

# With attribute
def chain_sum1(first):
    def wrapper(second=None):
        if second is None:
            return wrapper.result
        wrapper.result += second
        return wrapper
    wrapper.result = first
    return wrapper

# Without IF on try/exc =)
def chain_sum2(first):
    result = first
    def wrapper(second=None):
        nonlocal result
        try:
            second = int(second)
        except TypeError:
            return result
        result += second
        return wrapper
    return wrapper

# Without IF and try/exc on dict =D
def chain_sum3(first):
    def wrapper(second=None):
        def inner():
            wrapper.result += second
            return wrapper
        logic = {
            type(None): lambda: wrapper.result,
            int: inner 
        }
        return logic[type(second)]()
    wrapper.result = first
    return wrapper

# Without last function on class
class chainSum:
    def __init__(self, first):
        self._first = first

    def __call__(self, value=0):
        return chainSum(self._first + value)

    def __str__(self):
        return str(self._first)


# On class but like int ======))))))))
class chainSum2(int):
    def __call__(self, add=0):
        return chainSum2(self + add)

print(1 + chainSum2(5))
print(1 + chainSum2(5)(2))
print(3 + chainSum2(5)(100)(-10))

