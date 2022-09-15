from flask import Response, Flask
import prometheus_client, time, random
from prometheus_client import Counter, Histogram

app = Flask("prometheus-app")

REQUESTS = Counter(
    "requests", "Index someshit counter",
    ["endpoint"]
)

TIMER = Histogram(
    "slow", "Slow requests",
    ["endpoint"]
)

@app.route("/metrics/")
def metrics():
    return Response(
        prometheus_client.generate_latest(),
        mimetype="text/plain; version=0.0.4; charset=utf-8"
    )

@app.route("/")
def index():
    REQUESTS.labels(endpoint="/").inc()
    return "<h1>Test someshit counter</h1>"

@app.route("/database/")
def database():
    with TIMER.labels("/database").time():
        time.sleep(random.uniform(1, 3))
    return "<h1>Database created.</h1>"

if __name__ == "__main__":
    app.run(debug=True)
