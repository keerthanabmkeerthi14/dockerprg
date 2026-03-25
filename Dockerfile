#use official python image as base
FROM python:3.11-slim

#set working directory
WORKDIR /app

#copy files into container
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

#Expose port
EXPOSE 5000

#run application
CMD ["python","app.py"]

