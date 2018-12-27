from math import *

def binom(a,b):
    if b>a or a < 0 or b < 0:
        raise ValueError("Bad input for binomial function")
    return factorial(a)/(factorial(b)*factorial(a-b))
