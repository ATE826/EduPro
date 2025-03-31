package models

import "gorm.io/gorm"

// Модель Task
type Task struct {
	gorm.Model
	Question string `gorm:"size:255;not null;" json:"questions"` // Вопрос задания
	Answer   string `gorm:"size:255;not null;" json:"answer"`    // Ответ на задание
	TestID   uint   `gorm:"not null;" json:"test_id"`            // Внешний ключ для связи с Test
}
