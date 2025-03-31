package handlers

import (
	"EduPro/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

type TestInput struct {
	Task []models.Task `json:"task"`
}

func (s *Server) CreateTest(c *gin.Context) {
	var input TestInput

	if err := c.ShouldBind(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	test := models.Test{
		Task: input.Task,
	}

	var course models.Course                                                   // Получаем курс, к которому будем приписывать тест
	if err := s.db.First(&course, "id = ?", c.Param("id")).Error; err != nil { // Ищем курс по ID
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	// Добавляем тест к курсу
	course.Test = test

	// Сохраняем тест и курс
	if err := s.db.Create(&test).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := s.db.Save(&course).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Test created and added to course"})
}
