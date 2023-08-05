# Some python samples
import matplotlib.pyplot as plt

def ball_trajectory(x):
    location = 10*x - 5*(x**2)
    return(location)

xs = [x/100 for x in list(range(201))]
ys = [ball_trajectory(x) for x in xs]
plt.plot(xs, ys)
plt.title("The trajectory of a ball")
plt.xlabel("Horizontal position of ball")
plt.ylabel("Vertical position of ball")
plt.axhline(y = 0)
plt.show()




