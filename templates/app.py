import os
import sys
import time
import platform
import random
from flask import Flask, render_template, jsonify

app = Flask(__name__)

# Track start time for uptime calculation
START_TIME = time.time()
REQUEST_COUNT = 0

@app.before_request
def count_requests():
    global REQUEST_COUNT
    REQUEST_COUNT += 1

def get_uptime():
    diff = time.time() - START_TIME
    days, remain = divmod(diff, 86400)
    hours, remain = divmod(remain, 3600)
    minutes, seconds = divmod(remain, 60)
    
    parts = []
    if days > 0:
        parts.append(f"{int(days)}d")
    if hours > 0:
        parts.append(f"{int(hours)}h")
    if minutes > 0:
        parts.append(f"{int(minutes)}m")
    parts.append(f"{int(seconds)}s")
    
    return " ".join(parts)

@app.route('/')
def index():
    # Gather environment metadata
    metadata = {
        "os_name": platform.system(),
        "os_release": platform.release(),
        "python_version": sys.version.split()[0],
        "container_id": os.environ.get("HOSTNAME", "Local Environment"),
        "acr_registry": "learnacrolamc.azurecr.io",
        "aci_group": "flask-acr-demo",
        "region": "westeurope",
        "sku": "Basic (Registry) / Standard (ACI)"
    }
    return render_template('index.html', metadata=metadata, uptime=get_uptime(), req_count=REQUEST_COUNT)

@app.route('/api/metrics')
def metrics():
    # Return simulated system metrics that fluctuate dynamically
    # CPU usage: random walk around 15-40%
    cpu_usage = round(random.uniform(12.0, 35.0), 1)
    # Memory: random walk around 45-55%
    mem_usage = round(random.uniform(42.0, 52.0), 1)
    
    return jsonify({
        "uptime": get_uptime(),
        "req_count": REQUEST_COUNT,
        "cpu": cpu_usage,
        "memory": mem_usage,
        "timestamp": time.strftime("%H:%M:%S")
    })

if __name__ == '__main__':
    # Bind to port 80 or environment port
    port = int(os.environ.get("PORT", 80))
    app.run(host='0.0.0.0', port=port, debug=False)
