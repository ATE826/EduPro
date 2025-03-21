package main

import (
	"EduPro/handlers"
	"EduPro/models"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"gorm.io/gorm"
)

func DbInit() *gorm.DB {
	db, err := models.Setup() // Инициализация подключения к БД
	if err != nil {
		log.Println("Can't connect to database")
	}

	return db
}

func SetupRouter() *gin.Engine {
	r := gin.Default() // Создание экземпляра сервера

	db := DbInit() // Инициализация подключения к БД

	server := handlers.NewServer(db) // Создание экземпляра сервера

	router := r.Group("/api") // Создание группы маршрутов

	router.POST("/register", server.Register) // Регистрация пользователя
	router.POST("/login", server.Login)       // Вход пользователя

	return r
}

func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("Error loading .env file") // Загрузка файла .env
	}
	port := os.Getenv("PORT") // Получение порта из файла .env

	r := SetupRouter() // Создание экземпляра сервера

	log.Fatal(r.Run(":" + port)) // Запуск сервера
}
