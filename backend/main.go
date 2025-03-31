package main

import (
	"EduPro/handlers"
	"EduPro/middleware"
	"EduPro/models"
	"log"
	"os"
	"time"

	"github.com/gin-contrib/cors"
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

	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"},
		AllowHeaders:     []string{"Content-Type", "Authorization"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	router := r.Group("/api") // Создание группы маршрутов

	// Регистрация и вход пользователя
	router.POST("/register", server.Register)
	router.POST("/login", server.Login)

	//
	courses := r.Group("/course")
	courses.Use(middleware.JWTMiddleware())

	// Маршруты для курсов

	courses.POST("/createCourse", server.CreateCourse)       // Создание курса
	courses.DELETE("/deleteCourse/:id", server.DeleteCourse) // Удаление курса
	courses.GET("/allCourses", server.GetAllCourses)         // Получение всех курсов
	courses.GET("/course/:id", server.GetCourse)             // Получение курса по id

	// Маршруты для тестов
	router.POST("/course/:id/test", server.CreateTest)   // Создание теста для курса
	router.GET("/course/:id/test", server.GetTest)       // Получение теста для курса
	router.DELETE("/course/:id/test", server.DeleteTest) // Удаление теста для курса

	// Маршруты для задач
	router.POST("/course/:id/test/:id/task", server.CreateTask)       // Создание задачи для теста
	router.GET("/course/:id/test/:id/AllTasks", server.GetAllTasks)   // Получение всех задач для теста
	router.DELETE("/course/:id/test/:id/task/:id", server.DeleteTask) // Удаление задачи для теста

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
