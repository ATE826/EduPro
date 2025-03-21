package utils

import (
	"EduPro/models"
	"os"
	"strconv"
)

func GenerateToken(user models.User) (string, error) { // Генерация токена
	tokenLifespan, err := strconv.Atoi(os.Getenv("TOKEN_HOUR_LIFESPAN")) // Получение времени жизни токена из файла .env
}
