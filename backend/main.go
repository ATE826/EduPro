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

	// Маршруты для курсов
	courses := r.Group("/courses")
	courses.Use(middleware.JWTMiddleware())

	courses.POST("/", server.CreateCourse)
	courses.DELETE("/:course_id", server.DeleteCourse) // Изменил :id -> :course_id
	courses.GET("/", server.GetAllCourses)
	courses.GET("/:course_id", server.GetCourse) // Изменил :id -> :course_id

	// Маршруты для тестов (внутри курсов)
	tests := r.Group("/tests")
	tests.Use(middleware.JWTMiddleware())

	tests.POST("/", server.CreateTest)
	tests.GET("/:test_id", server.GetTest)
	tests.DELETE("/:test_id", server.DeleteTest)

	// Маршруты для задач (внутри тестов)
	tasks := r.Group("/tasks")
	tasks.Use(middleware.JWTMiddleware())

	tasks.POST("/", server.CreateTask)
	tasks.GET("/", server.GetAllTasks)
	tasks.DELETE("/:task_id", server.DeleteTask)

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
