FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# System packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    vim \
    tmux \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# SSH setup
RUN mkdir /var/run/sshd

# Create user
RUN useradd -ms /bin/bash developer

# Optional: give sudo
RUN echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set password (CHANGE THIS)
RUN echo 'developer:developer' | chpasswd

# Install Python packages
RUN pip3 install --upgrade pip setuptools wheel

# PyTorch CUDA
RUN pip install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu124

# LLM packages
RUN pip install \
    transformers \
    accelerate \
    datasets \
    peft \
    trl \
    openai \
    anthropic \
    tiktoken \
    jupyterlab \
    pandas \
    numpy \
    matplotlib \
    scipy \
    scikit-learn \
    tqdm \
    huggingface_hub

WORKDIR /workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]