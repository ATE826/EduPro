package handlers

import (
	"EduPro/models"
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type RegisterInput struct { // Структура для валидации данных при регистрации
	FirstName  string `json:"first_name" binding:"required"`
	LastName   string `json:"last_name" binding:"required"`
	Patronymic string `json:"patronymic" binding:"required"`
	Email      string `json:"email" binding:"required"`
	Password   string `json:"password" binding:"required"`
	City       string `json:"city" binding:"required"`
	Birthday   string `json:"birthday" binding:"required"`
}

type LoginInput struct { // Структура для валидации данных при входе
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type Server struct { // Структура для хранения экземпляра сервера и экземпляра базы данных
	db *gorm.DB
}

func NewServer(db *gorm.DB) *Server { // Функция для создания экземпляра сервера
	return &Server{db: db}
}

func (s *Server) Register(c *gin.Context) { // Функция для регистрации пользователя
	var input RegisterInput

	if err := c.ShouldBind(&input); err != nil { // Проверка валидности данных
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()}) // Отправка ошибки, если данные не валидны
	}

	user := models.User{ // Создание экземпляра пользователя
		FirstName:  input.FirstName,
		LastName:   input.LastName,
		Patronymic: input.Patronymic,
		Email:      input.Email,
		Password:   input.Password,
		City:       input.City,
		Birthday:   input.Birthday,
	}

	user.HashPassword() // Хеширование пароля

	if err := s.db.Create(&user).Error; err != nil { // Проверка на ошибку при создании пользователя
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	c.JSON(http.StatusCreated, gin.H{"message": "User created"}) // Отправка сообщения об успешной регистрации
}
