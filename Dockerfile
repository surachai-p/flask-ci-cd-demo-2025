# 1. Base Image ที่เบาและปลอดภัย
FROM python:3.9-slim

# 2. ติดตั้ง Build Tools และ Security Tools (รวม curl สำหรับ Health Check)
# 🚨 SECURITY: ติดตั้ง/อัปเดตและลบ cache ในคำสั่งเดียว เพื่อลดขนาด Image Layer
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# 3. กำหนด Working Directory (ใช้ /usr/src/app เพื่อความชัดเจน)
WORKDIR /app
ENV PYTHONPATH=/app
# 4. Copy requirements และติดตั้ง (Layer Caching)
# 💡 Docker Cache: การติดตั้ง Dependencies ควรเป็น Layer แรกๆ
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy Application Code
# 💡 โค้ดทั้งหมดใน backend/ ถูก Copy ไปที่ Working Directory (/usr/src/app)
COPY backend/ .

# 6. EXPOSE Port (ใช้ Port 5000 ตาม Default ของ Flask)
EXPOSE 5001

# 7. Command
# 💡 รันแอปพลิเคชัน Flask
CMD ["python", "app.py"]