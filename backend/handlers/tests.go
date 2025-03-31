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
		Tasks: input.Task, // Изменил Task -> Tasks
	}

	var course models.Course                                                   // Получаем курс, к которому будем приписывать тест
	if err := s.db.First(&course, "id = ?", c.Param("id")).Error; err != nil { // Ищем курс по ID
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	// Добавляем тест к курсу
	course.TestId = &test.ID

	// Сохраняем тест и курсv
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

func (s *Server) GetTest(c *gin.Context) {
	id := c.Param("id") // Получаем ID курса из параметров запроса

	var test models.Test                                // Создаём переменную для хранения теста
	if err := s.db.First(&test, id).Error; err != nil { // Ищем тест по ID
		c.JSON(http.StatusNotFound, gin.H{"error": "Test not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"test": test}) // Возвращаем тест в формате JSON
}

func (s *Server) DeleteTest(c *gin.Context) {
	id := c.Param("id") // Получаем ID теста из параметров запроса

	var test models.Test                                // Создаём переменную для хранения теста
	if err := s.db.First(&test, id).Error; err != nil { // Ищем тест по ID
		c.JSON(http.StatusNotFound, gin.H{"error": "Test not found"})
		return
	}

	if err := s.db.Delete(&test).Error; err != nil { // Удаляем тест
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Test deleted"}) // Возвращаем сообщение об успешном удалении
}
