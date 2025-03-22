package handlers

import (
	"EduPro/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

type CourseInput struct {
	Title       string `json:"title" binding:"required"`
	Category    string `json:"category" binding:"required"`
	Description string `json:"description" binding:"required"`
	Video       string `json:"video" binding:"required"`
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
	}

	if err := s.db.Create(&course).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Course created"})
}
