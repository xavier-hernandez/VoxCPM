FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HF_HOME=/models/huggingface
ENV TRANSFORMERS_CACHE=/models/huggingface
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip git ffmpeg libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/OpenBMB/VoxCPM.git .

RUN python3.11 -m pip install --upgrade pip && \
    python3.11 -m pip install torch torchaudio --index-url https://download.pytorch.org/whl/cu124 && \
    python3.11 -m pip install -e .

EXPOSE 8808

CMD ["python3.11", "app.py", "--port", "8808", "--device", "cuda"]
