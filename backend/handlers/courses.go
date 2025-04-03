package handlers

import (
	"EduPro/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type CourseInput struct {
	Title       string `json:"title" binding:"required"`
	Category    string `json:"category" binding:"required"`
	Description string `json:"description" binding:"required"`
	Video       string `json:"video" binding:"required"`
	UserId      uint   `json:"user_id" binding:"required"`
	TestId      *uint  `json:"test_id"` // Теперь указатель, чтобы поддерживать null
}

type TestInput struct {
	Title string        `json:"title" binding:"required"`
	Task  []models.Task `json:"task"`
}

func (s *Server) CreateCourse(c *gin.Context) {
	var input CourseInput

	// Проверка на валидность данных
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Создание объекта Course
	course := models.Course{
		Title:       input.Title,
		Category:    input.Category,
		Description: input.Description,
		Video:       input.Video,
		UserId:      input.UserId,
		TestId:      input.TestId, // Поддержка null
	}

	// Сохранение курса в базе данных
	if err := s.db.Create(&course).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Course created", "course": course})
}

func (s *Server) DeleteCourse(c *gin.Context) {
	// Получаем Id курса из параметров запроса
	id := c.Param("course_id")

	courseId, err := strconv.Atoi(id)
	if err != nil {
		return
	}
	// Ищем курс по Id
	var course models.Course
	if err := s.db.First(&course, courseId).Error; err != nil {
		// Если курс не найден, возвращаем ошибку
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	// Удаляем курс
	if err := s.db.Delete(&course, id).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to delete course"})
		return
	}

	// Возвращаем сообщение об успешном удалении
	c.JSON(http.StatusOK, gin.H{"message": "Course deleted"})
}

func (s *Server) GetAllCourses(c *gin.Context) {
	var courses []models.Course

	// Получаем все курсы
	if err := s.db.Find(&courses).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Failed to get courses"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"courses": courses})
}

func (s *Server) GetCourse(c *gin.Context) {
	// Получаем Id курса из параметров запроса
	id := c.Param("course_id")

	courseId, err := strconv.Atoi(id)
	if err != nil {
		return
	}

	// Ищем курс по Id
	var course models.Course
	if err := s.db.First(&course, courseId).Error; err != nil {
		// Если курс не найден, возвращаем ошибку
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"course": course})
}

func (s *Server) CreateTest(c *gin.Context) {
	// Получаем Id курса из параметров запроса
	id := c.Param("course_id")

	courseId, err := strconv.Atoi(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid course ID"})
		return
	}

	// Ищем курс по Id
	var course models.Course
	if err := s.db.First(&course, courseId).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	var input TestInput

	// Проверка на валидность данных
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	test := models.Test{
		CourseID: uintPtr(uint(courseId)), // Создаем указатель на uint
		Title:    input.Title,
		Tasks:    []models.Task{}, // Пустой срез, если задач нет
	}

	// Сохраняем тест в базе данных
	if err := s.db.Create(&test).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Обновляем поле TestId в курсе
	course.TestId = &test.ID
	if err := s.db.Save(&course).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update course with test ID"})
		return
	}

	// Возвращаем успешный ответ с созданным тестом
	c.JSON(http.StatusCreated, gin.H{"message": "Test created successfully", "test": test})
}

func (s *Server) DeleteTest(c *gin.Context) {
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

	// Удаляем тест
	if err := s.db.Delete(&test).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete test"})
		return
	}

	// Обнуляем TestId у курса
	course.TestId = nil
	if err := s.db.Save(&course).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update course"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Test deleted successfully"})
}

func (s *Server) GetTest(c *gin.Context) {
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

	// Ищем тест по ID с подгрузкой задач
	var test models.Test
	if err := s.db.Preload("Tasks").First(&test, testID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Test not found"})
		return
	}

	// Если задач нет, заменяем null на пустой срез
	if test.Tasks == nil {
		test.Tasks = []models.Task{} // Возвращаем пустой массив, если задач нет
	}

	c.JSON(http.StatusOK, gin.H{"test": test})
}

// Функция для создания указателя на uint
func uintPtr(i uint) *uint {
	return &i
}
