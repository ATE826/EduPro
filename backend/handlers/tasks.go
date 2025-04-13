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
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "cannot get user_id"})
		c.Abort()
		return
	}

	// Получаем пользователя по его ID
	var user models.User
	if err := s.db.First(&user, userId).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "user not found"})
		return
	}

	// Проверка, что пользователь заблокирован
	if user.IsBlocked {
		c.JSON(http.StatusForbidden, gin.H{"error": "user is blocked"})
		return
	}

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

func (s *Server) DeleteTask(c *gin.Context) {
	course_id := c.Param("course_id")
	test_id := c.Param("test_id")
	task_id := c.Param("task_id")

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

	taskID, err := strconv.Atoi(task_id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid task ID"})
		return
	}

	// Проверяем курс
	var course models.Course
	if err := s.db.First(&course, courseID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	// Проверяем тест
	var test models.Test
	if err := s.db.First(&test, testID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Test not found"})
		return
	}
	if test.CourseID == nil || *test.CourseID != uint(courseID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "This test does not belong to the specified course"})
		return
	}

	// Проверяем задание
	var task models.Task
	if err := s.db.First(&task, taskID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Task not found"})
		return
	}
	if task.TestID != uint(testID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "This task does not belong to the specified test"})
		return
	}

	// Удаляем задание
	if err := s.db.Delete(&task).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to delete task"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Task deleted"})
}

func (s *Server) GetTask(c *gin.Context) {
	course_id := c.Param("course_id")
	test_id := c.Param("test_id")
	task_id := c.Param("task_id")

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

	taskID, err := strconv.Atoi(task_id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid task ID"})
		return
	}

	// Проверяем курс
	var course models.Course
	if err := s.db.First(&course, courseID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	// Проверяем тест
	var test models.Test
	if err := s.db.First(&test, testID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Test not found"})
		return
	}
	if test.CourseID == nil || *test.CourseID != uint(courseID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "This test does not belong to the specified course"})
		return
	}

	// Проверяем задание
	var task models.Task
	if err := s.db.First(&task, taskID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Task not found"})
		return
	}
	if task.TestID != uint(testID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "This task does not belong to the specified test"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"task": task})
}
