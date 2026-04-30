FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=utf-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-venv python3-pip \
    git curl ca-certificates unzip \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3.10 /usr/bin/python \
    && python -m pip install --upgrade pip setuptools wheel

RUN pip install \
    torch==2.6.0+cu124 \
    torchvision==0.21.0 \
    torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu124

# xformers (torch 2.6 + cu124 매칭)
RUN pip install xformers==0.0.29.post3 --index-url https://download.pytorch.org/whl/cu124

# 학습 의존성
RUN pip install \
    ipykernel==6.29.5 \
    unsloth==2025.3.19 \
    gdown==5.2.0 \
    huggingface_hub==0.36.2 \
    transformers==4.51.3 \
    peft==0.13.2 \
    accelerate==0.34.0 \
    bitsandbytes \
    protobuf==3.20.3

# unsloth와 호환 안 되는 torchao 제거 (노트북 cell-3와 동일 처리)
RUN pip uninstall -y torchao || true

# papermill / nbconvert (Run에서 노트북 실행)
RUN pip install papermill jupyter nbconvert

WORKDIR /workspace