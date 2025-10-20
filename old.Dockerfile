# ----- Nonworking old Dockerfile - Base image not compatible -----
FROM nvcr.io/nvidia/pytorch:23.10-py3

WORKDIR /app

COPY requirements.txt .

ENV HF_HOME=/app/.cache/huggingface
ENV TRANSFORMERS_CACHE=/app/.cache/huggingface/hub
ENV HF_DATASETS_CACHE=/app/.cache/huggingface/datasets


COPY requirements.txt .
# This **should** install torch==2.1.1 over the base image's version.

RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade --force-reinstall transformer-engine



# --- Custom file replacement for bidirectional attention ---
COPY modeling_mistral.py /tmp/modeling_mistral.py

# 2. Find the installed transformers package path and overwrite the original file.
RUN TRANSFORMERS_PATH=$(python -c "import transformers; import os; print(os.path.dirname(transformers.__file__))") && \
    cp /tmp/modeling_mistral.py $TRANSFORMERS_PATH/models/mistral/modeling_mistral.py && \
    rm /tmp/modeling_mistral.py


COPY config/ ./config
COPY training/ ./training
COPY inference_ReRICR.py .
COPY ReFICR.py .
COPY requirements.txt .
COPY run.sh .
COPY utils.py .



# Creates a new user called reficr-user and sets it as the user to run the container - this is very nice for security :))
RUN groupadd -r reficr-group && useradd -r -g reficr-group reficr-user

RUN chown -R reficr-user:reficr-group /app

USER reficr-user

EXPOSE 5000

CMD ["sh", "run.sh"]