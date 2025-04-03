package handlers

import (
	"EduPro/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type TaskInput struct {
	Question string `json:"question" binding:"required"`
	Answer   string `json:"answer" binding:"required"`
}

func (s *Server) CreateTask(c *gin.Context) {
	// Получаем ID курса и теста из параметров запроса
	course_id := c.Param("course_id")
	test_id := c.Param("test_id")

	courseID, err := strconv.Atoi(course_id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid course ID"})
		return
	}

	testID, err := strconv.Atoi(test_id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid test ID"})
		return
	}

	// Ищем курс по ID
	var course models.Course
	if err := s.db.First(&course, courseID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	// Проверяем, что у курса действительно этот тест
	if course.TestId == nil || *course.TestId != uint(testID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "This course does not have the specified test"})
		return
	}

	// Ищем тест по ID
	var test models.Test
	if err := s.db.First(&test, testID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Test not found"})
		return
	}

	var input TaskInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	task := models.Task{
		TestID:   uint(testID), // Преобразуем testID в uint
		Question: input.Question,
		Answer:   input.Answer,
	}

	// Сохраняем задачу в базе данных
	if err := s.db.Create(&task).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Обновляем поле TaskId в тесте
	test.Tasks = append(test.Tasks, task)
	if err := s.db.Save(&test).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update test with new task"})
		return
	}
}
