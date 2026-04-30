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

# 노트북 cell-3와 동일한 순서로 한 줄씩 — 한 번에 묶으면 의존성 해석 충돌
RUN pip install ipykernel==6.29.5
RUN pip install unsloth==2025.3.19
RUN pip install gdown==5.2.0
RUN pip install huggingface_hub==0.36.2
RUN pip uninstall -y torchao || true
RUN pip install transformers==4.51.3
RUN pip install peft==0.13.2
RUN pip install accelerate==0.34.0
RUN pip install bitsandbytes
RUN pip install protobuf==3.20.3

# papermill / nbconvert (Run에서 노트북 실행)
RUN pip install papermill jupyter nbconvert

WORKDIR /workspace