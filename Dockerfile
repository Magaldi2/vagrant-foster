FROM python:3.9-slim

LABEL maintainer="your-email@example.com"
LABEL description="Flask ML API"

WORKDIR /app

# --- CORREÇÃO AQUI: Instala libs de sistema para OpenCV/Matplotlib ---
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*
# ---------------------------------------------------------------------

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY flaskapp/ ./flaskapp/
COPY mlp-scratch/ ./mlp-scratch/

RUN mkdir -p /app/logs

EXPOSE 5000

ENV FLASK_APP=flaskapp/app.py
ENV PYTHONUNBUFFERED=1

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]