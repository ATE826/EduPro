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
	router.GET("/", server.GetAllCourses)

	// Админ
	admin := r.Group("/admin")
	admin.Use(middleware.JWTMiddleware()) // Использование JWT для защиты маршрутов

	admin.GET("/users", server.GetAllUsers)
	admin.GET("/users/:user_id", server.GetUser)
	admin.PATCH("/users/:user_id", server.BlockUser)

	// Получение текущего пользователя
	user := r.Group("/user")
	user.Use(middleware.JWTMiddleware())

	user.GET("/", server.GetCurrentUser)
	user.PATCH("/", server.UpdateUser)
	user.DELETE("/", server.DeleteUser)

	// Маршруты для курсов
	courses := r.Group("/courses")
	courses.Use(middleware.JWTMiddleware())

	courses.POST("/", server.CreateCourse)
	courses.POST("/:course_id", server.CreateTest)
	courses.POST("/:course_id/:test_id/", server.CreateTask)

	courses.DELETE("/:course_id", server.DeleteCourse)
	courses.DELETE("/:course_id/:test_id", server.DeleteTest)
	courses.DELETE("/:course_id/:test_id/:task_id", server.DeleteTask)

	courses.GET("/", server.GetAllUsersCourses)
	courses.GET("/:course_id", server.GetCourse)
	courses.GET("/:course_id/:test_id", server.GetTest)
	courses.GET("/:course_id/:test_id/:task_id", server.GetTask)

	courses.PATCH("/:course_id", server.UpdateCourse)
	courses.PATCH("/:course_id/:test_id", server.UpdateTest)
	courses.PATCH("/:course_id/:test_id/:task_id", server.UpdateTask)

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
