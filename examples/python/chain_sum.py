# Some tests
def chain_sum(first):
    result = first
    def wrapper(second=None):
        nonlocal result
        if second is None:
            return result
        result += second
        return wrapper
    return wrapper

print(chain_sum(5)())
print(chain_sum(5)(2)())
print(chain_sum(5)(100)(-10)())
