package utils

import (
	"EduPro/models"
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

func GenerateToken(user models.User) (string, error) { // Генерация токена
	tokenLifespan, err := strconv.Atoi(os.Getenv("TOKEN_HOUR_LIFESPAN")) // Получение времени жизни токена из файла .env

	if err != nil {
		return "", err
	}

	// Создание полезной нагрузки токена
	claims := jwt.MapClaims{}
	claims["authorized"] = true
	claims["user_id"] = user.ID
	claims["exp"] = time.Now().Add(time.Hour * time.Duration(tokenLifespan)).Unix()

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims) // Создание токена

	return token.SignedString([]byte(os.Getenv("API_SECRET"))) // Подпись токена
}

func VerifyToken(c *gin.Context) error {
	token, err := GetToken(c)

	if err != nil {
		return err
	}

	_, ok := token.Claims.(jwt.MapClaims) // Проверка на тип полезной нагрузки
	if ok && token.Valid {                // Проверка на валидность токена
		return nil
	}

	return errors.New("invalid token") // Ошибка, если токен не валиден
}

func GetToken(c *gin.Context) (*jwt.Token, error) {
	tokenString := getTokenFromRequest(c)
	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}

		return []byte(os.Getenv("API_SECRET")), nil
	})
	return token, err
}

func getTokenFromRequest(c *gin.Context) string {
	bearerToken := c.Request.Header.Get("Authorization") // Получение токена из заголовка запроса

	splitToken := strings.Split(bearerToken, " ") // Разделение токена на части
	if len(splitToken) == 2 {
		return splitToken[1]
	}

	return ""
}

func ValidateToken(c *gin.Context) error {
	token, err := GetToken(c)

	if err != nil {
		return err
	}

	_, ok := token.Claims.(jwt.MapClaims)
	if ok && token.Valid {
		return nil
	}

	return errors.New("invalid token provided")
}
