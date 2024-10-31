# Compile image
FROM ubuntu:noble AS compile-image

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app  # Ensure the work directory is set early

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip python3-venv python3-dev pkg-config libhdf5-dev build-essential gcc && \
    cd /usr/local/bin && \
    ln -s /usr/bin/python3 python && \
    python3 --version && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt

RUN python3 -m venv venv && \
    venv/bin/pip install --no-cache-dir -r requirements.txt && \
    pip list

RUN venv/bin/pip install pyinstaller

COPY uptonight uptonight
COPY targets targets
COPY main.py .
COPY server.py .  # Add server.py to the image

RUN venv/bin/pyinstaller --recursive-copy-metadata matplotlib --collect-all dateutil --onefile main.py 

# Run image
FROM ubuntu:noble AS runtime-image

WORKDIR /app  # Set the work directory again for the runtime image

# Copy only the necessary files from the build stage
COPY --from=compile-image /app/dist/main /app/main
COPY --from=compile-image /app/targets /app/targets
COPY --from=compile-image /app/server.py /app/server.py  # Ensure server.py is in runtime image
COPY --from=compile-image /app/config.yaml /app/config.yaml  # Ensure config.yaml is in runtime image

# Set server.py as the entry point to start the Flask server
CMD ["python", "server.py"]
