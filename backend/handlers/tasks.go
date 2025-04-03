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
	courseID, err := strconv.Atoi(c.Param("course_id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid course ID"})
		return
	}

	testID, err := strconv.Atoi(c.Param("test_id"))
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

	// Проверяем, что у курса действительно есть этот тест
	if course.TestId == nil || *course.TestId != uint(testID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "This course does not have the specified test"})
		return
	}

	// Ищем тест по ID с подгрузкой задач
	var test models.Test
	if err := s.db.Preload("Tasks").First(&test, testID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Test not found"})
		return
	}

	// Привязываем входные данные к структуре Task
	var input TaskInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	task := models.Task{
		TestID:   uint(testID),
		Question: input.Question,
		Answer:   input.Answer,
	}

	//fmt.Printf("Creating task: %+v\n", task) // Отладочный вывод

	// Сохраняем задачу в базе данных
	if err := s.db.Create(&task).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Task created", "task": task})
}
