package models

import "gorm.io/gorm"

// Модель Task
type Task struct {
	gorm.Model
	Questions string `gorm:"size:255;not null;" json:"questions"`
	Answer    string `gorm:"size:255;not null;" json:"answer"`
	TestID    uint   `gorm:"not null;" json:"test_id"` // Внешний ключ для связи с Test
}
