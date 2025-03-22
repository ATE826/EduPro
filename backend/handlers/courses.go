package handlers

import (
	"EduPro/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

type CourseInput struct {
	Title       string      `json:"title" binding:"required"`
	Category    string      `json:"category" binding:"required"`
	Description string      `json:"description" binding:"required"`
	Video       string      `json:"video" binding:"required"`
	UserId      uint        `json:"user_id" binding:"required"`
	Test        models.Test `json:"test"`
}

func (s *Server) CreateCource(c *gin.Context) {
	var input CourseInput

	if err := c.ShouldBind(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	course := models.Course{ // Создание экземпляра курса
		Title:       input.Title,
		Category:    input.Category,
		Description: input.Description,
		Video:       input.Video,
		Test:        input.Test,
	}

	// Получение пользователя, которому будем приписывать курс
	var user models.User
	if err := s.db.First(&user, "id = ?", input.UserId).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Добавляем курс к пользователю
	user.Courses = append(user.Courses, course)

	// Сохраняем курс и пользователя
	if err := s.db.Create(&course).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := s.db.Save(&user).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Course created and added to user"})
}
