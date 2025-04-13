package handlers

import (
	"EduPro/models"
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

func (s *Server) GetCurrentUser(c *gin.Context) {
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var user models.User

	// Подгружаем курсы и тесты в курсах
	if err := s.db.Preload("Courses.Test").First(&user, userId).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Не возвращаем пароль
	user.Password = ""

	c.JSON(http.StatusOK, gin.H{"user": user})
}

type UserUpdateInput struct {
	FirstName  string `json:"first_name"`
	LastName   string `json:"last_name"`
	Patronymic string `json:"patronymic"`
	City       string `json:"city"`
	Birthday   string `json:"birthday"`
	Email      string `json:"email"`
	Password   string `json:"password"` // Если новый пароль передается
}

func (s *Server) UpdateUser(c *gin.Context) {
	// Получаем ID текущего пользователя из контекста (например, из JWT)
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var user models.User
	// Находим пользователя по его ID
	if err := s.db.First(&user, userId).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Если пользователь заблокирован, не позволяем ему обновлять данные
	if user.IsBlocked {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User is blocked"})
		return
	}

	// Структура для входных данных
	var input UserUpdateInput
	// Привязываем входные данные
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Проверка уникальности email, если он изменился
	if input.Email != "" && input.Email != user.Email {
		var existingUser models.User
		if err := s.db.Where("email = ?", input.Email).First(&existingUser).Error; err == nil {
			c.JSON(http.StatusConflict, gin.H{"error": "Email is already in use"})
			return
		}
	}

	// Хеширование пароля, если он передан
	if input.Password != "" {
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(input.Password), bcrypt.DefaultCost)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
			return
		}
		// Заменяем на хешированный пароль
		input.Password = string(hashedPassword)
	}

	// Строим обновляемую карту
	updateData := map[string]interface{}{}

	// Добавляем только те поля, которые были переданы
	if input.FirstName != "" {
		updateData["first_name"] = input.FirstName
	}
	if input.LastName != "" {
		updateData["last_name"] = input.LastName
	}
	if input.Patronymic != "" {
		updateData["patronymic"] = input.Patronymic
	}
	if input.City != "" {
		updateData["city"] = input.City
	}
	if input.Birthday != "" {
		updateData["birthday"] = input.Birthday
	}
	if input.Email != "" {
		updateData["email"] = input.Email
	}
	if input.Password != "" {
		updateData["password"] = input.Password
	}

	// Обновляем только те поля, которые есть в карте
	if err := s.db.Model(&user).Updates(updateData).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User updated successfully"})
}

func (s *Server) DeleteUser(c *gin.Context) {

	// Получаем ID текущего пользователя из контекста (например, из JWT)
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var user models.User
	// Находим пользователя по его ID
	if err := s.db.First(&user, userId).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if err := s.db.Delete(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})
}
