#!/bin/bash
#!/bin/bash

# if  error -> stop script run
set -e

if [ $# -eq 0 ]; then
    echo "Ошибка: Не указан URL удалённого репозитория."
    echo "Пример использования: $0 https://github.com/username/repo.git"
    exit 1
fi

REMOTE_URL=$1
COMMIT_MESSAGE=${2:-"Initial commit"} # Сообщение по умолчанию

echo "1. init .git file(repository)"
git init

echo "2.add all local repository files to git"
git add .

echo "3.add commit with messange: '$COMMIT-MESSAGE'"
git commit -m "$COMMIT_MESSAGE"

echo "4.init main branch"
git branch -M main

echo "5.add remote repository: $REMOTE_URL"
git remote add origin $REMOTE_URL

echo "6.push remote repository"
git push -u origin main

echo "Repository succesfull set"
