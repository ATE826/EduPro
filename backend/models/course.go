package models

import "gorm.io/gorm"

// Модель Course
type Course struct {
	gorm.Model
	Title       string `gorm:"size:255;not null;" json:"title"`
	Category    string `gorm:"size:255;not null;" json:"category"`
	Description string `gorm:"size:255;not null;" json:"description"`
	Video       string `gorm:"size:255;not null;" json:"video"`
	UserId      uint   `gorm:"size:255;not null;" json:"user_id"`   // Id пользователя-создателя курса
	TestId      uint   `gorm:"foreignkey:CourseID;" json:"test_id"` // Связь с Test через внешний ключ CourseID
}
