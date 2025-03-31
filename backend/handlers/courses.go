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
	UserId      uint   `json:"user_id" binding:"required"`
	TestId      uint   `json:"test_id"`
}

func (s *Server) CreateCourse(c *gin.Context) {
	var input CourseInput

	// Проверка на валидность данных
	if err := c.ShouldBind(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Проверка, существует ли тест с данным TestId
	var test models.Test
	result := s.db.First(&test, input.TestId)
	if result.Error != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Test not found"})
		return
	}

	// Создание курса
	course := models.Course{
		Title:       input.Title,
		Category:    input.Category,
		Description: input.Description,
		Video:       input.Video,
		TestId:      input.TestId, // Привязка курса к тесту
	}

	// Получение пользователя
	userId, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "cannot get user_id"})
		c.Abort()
		return
	}

	var user models.User
	result = s.db.First(&user, userId)
	if result.Error != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "cannot find user"})
		c.Abort()
		return
	}

	// Привязываем курс к пользователю
	course.UserId = user.ID

	// Сохраняем курс в базе данных
	if err := s.db.Create(&course).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Обновляем информацию о курсах пользователя
	user.Courses = append(user.Courses, course)

	// Сохраняем обновления пользователя в базе данных
	if err := s.db.Save(&user).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Возвращаем сообщение об успешном создании курса
	c.JSON(http.StatusCreated, gin.H{"message": "Course created and added to user"})
}

func (s *Server) DeleteCourse(c *gin.Context) {
	// Получаем Id курса из параметров запроса
	id := c.Param("id")

	// Ищем курс по Id
	var course models.Course
	if err := s.db.First(&course, id).Error; err != nil {
		// Если курс не найден, возвращаем ошибку
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	// Удаляем курс
	if err := s.db.Delete(&course).Error; err != nil {
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
	id := c.Param("id")

	// Ищем курс по Id
	var course models.Course
	if err := s.db.First(&course, id).Error; err != nil {
		// Если курс не найден, возвращаем ошибку
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"course": course})
}
