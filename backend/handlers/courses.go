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
