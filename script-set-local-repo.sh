#!/bin/bash

# скрипт будет доработан, сейчас это просто сценарий настройки локального репозитория чтобы был

## 1. Создание локального репозитория

# Создаем папку для локального репозитория
mkdir -p /opt/local-repo

# Скачиваем несколько .deb пакетов для примера
cd /opt/local-repo
apt download htop nano wget

# Устанавливаем инструмент для создания репозитория
apt update
apt install -y dpkg-dev

# Создаем файл Packages для репозитория
cd /opt/local-repo
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

# Добавляем локальный репозиторий в sources.list
echo "deb [trusted=yes] file:/opt/local-repo ./" | tee /etc/apt/sources.list.d/local-repo.list

# Обновляем список пакетов
apt update

## 2. Проверка работы локального репозитория

# Смотрим доступные пакеты из локального репозитория
apt-cache policy htop

# Устанавливаем пакет из локального репозитория
apt install htop

# Проверяем что пакет установился
htop --version
# Пакеты должны показывать, что доступны из локального репозитория
apt-cache policy nano
apt-cache policy wget
# 1. Устанавливаем nginx
apt update && apt install -y nginx

# 2. Создаем конфиг для nginx
cat > /etc/nginx/sites-available/local-repo << 'EOF'
server {
    listen 80;
    server_name _;
    root /opt/local-repo;
    autoindex on;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Для правильной работы APT с файлами Packages/Packages.gz
    location ~ /(Packages|Packages.gz|Release|Release.gpg)$ {
        add_header Content-Type application/octet-stream;
    }
}
EOF

# 3. Активируем конфиг
ln -sf /etc/nginx/sites-available/local-repo /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
# 1. Проверяем что nginx установлен
which nginx

# 2. Останавливаем если запущен
nginx -s stop 2>/dev/null || true

# 3. Запускаем nginx в фоне
nginx

# 4. Проверяем что запустился
ps aux | grep nginx

# 5. Проверяем что файлы доступны по вебу
curl http://localhost/
curl http://localhost/Packages.gz
# Узнаем IP первого контейнера
# В ПЕРВОМ контейнере выполни:
hostname -I

# ВО ВТОРОМ контейнере:
# Добавляем репозиторий (замени IP на реальный адрес первого контейнера)
echo "deb [trusted=yes] http://172.17.0.2:80 ./" | tee /etc/apt/sources.list.d/remote-repo.list

# Обновляем
apt update

# Проверяем что пакеты видны
apt-cache policy htop
apt-cache policy nano

# Устанавливаем пакет
apt install htop

