package handlers

import (
	"EduPro/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

type TaskInput struct {
	Question string `json:"question" binding:"required"`
	Answer   string `json:"answer" binding:"required"`
}

func (s *Server) CreateTask(c *gin.Context) {
	var input TaskInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	task := models.Task{
		Question: input.Question,
		Answer:   input.Answer,
	}

	if err := s.db.Create(&task).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"task": task})
}

func (s *Server) GetAllTasks(c *gin.Context) {
	var tasks []models.Task

	// Ищем все задачи
	if err := s.db.Find(&tasks).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"tasks": tasks})
}

func (s *Server) DeleteTask(c *gin.Context) {
	id := c.Param("id") // Получаем ID задачи из параметров запроса

	var task models.Task                                // Создаём переменную для хранения задачи
	if err := s.db.First(&task, id).Error; err != nil { // Ищем задачу по ID
		c.JSON(http.StatusNotFound, gin.H{"error": "Task not found"})
		return
	}
	if err := s.db.Delete(&task).Error; err != nil { // Удаляем задачу
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Task deleted"})
}
