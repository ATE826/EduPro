package handlers

import (
	"EduPro/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (s *Server) GetAllUsers(c *gin.Context) {
	// Получаем информацию о текущем пользователе (из JWT или другого источника)
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var currentUser models.User
	if err := s.db.First(&currentUser, userId).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Проверяем, если текущий пользователь — администратор
	if currentUser.Role != "admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	// Получаем всех пользователей
	var users []models.User
	if err := s.db.Find(&users).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	// Возвращаем список пользователей без паролей
	for i := range users {
		users[i].Password = "" // Убираем пароль из ответа
	}

	c.JSON(http.StatusOK, gin.H{"users": users})
}

func (s *Server) GetUser(c *gin.Context) {
	// Проверка авторизации и роли
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	var currentUser models.User
	if err := s.db.First(&currentUser, userId).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if currentUser.Role != "admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	// Получение ID пользователя, которого надо найти
	targetID := c.Param("user_id")

	var targetUser models.User
	if err := s.db.First(&targetUser, targetID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Target user not found"})
		return
	}

	targetUser.Password = "" // не возвращаем пароль

	c.JSON(http.StatusOK, gin.H{"user": targetUser})
}

func (s *Server) BlockUser(c *gin.Context) {
	// Получаем ID пользователя из URL
	userID := c.Param("user_id")

	// Получаем текущего пользователя (из JWT)
	userData, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	// Проверка, что текущий пользователь — админ
	var currentUser models.User
	if err := s.db.First(&currentUser, userData).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "current user not found"})
		return
	}
	if currentUser.Role != "admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "access denied"})
		return
	}

	// Получаем пользователя по ID
	var user models.User
	if err := s.db.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}

	// Инвертируем флаг блокировки
	user.IsBlocked = !user.IsBlocked

	// Сохраняем изменения
	if err := s.db.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update user status"})
		return
	}

	status := "unblocked"
	if user.IsBlocked {
		status = "blocked"
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "user " + status,
		"user_id": user.ID,
	})
}
