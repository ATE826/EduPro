package handlers

import (
	"EduPro/models"
	"EduPro/utils"
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
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

func (s *Server) LoginCheck(email, password string) (string, error) {
	var err error

	user := models.User{}

	if err = s.db.Model(models.User{}).Where("email = ?", email).Take(&user).Error; err != nil {
		return "", err
	}

	err = user.VerifyPassword(password)

	if err != nil && err == bcrypt.ErrMismatchedHashAndPassword {
		return "", err
	}

	token, err := utils.GenerateToken(user)

	if err != nil {
		return "", err
	}

	return token, nil
}

func (s *Server) Login(c *gin.Context) { // Функция для входа пользователя
	var input LoginInput

	if err := c.ShouldBind(&input); err != nil { // Проверка валидности данных
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()}) // Отправка ошибки, если данные не валидны
		return
	}

	user := models.User{Email: input.Email, Password: input.Password} // Создание экземпляра пользователя

	token, err := s.LoginCheck(user.Email, user.Password)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token}) // Отправка токена

}
