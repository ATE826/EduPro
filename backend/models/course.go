package models

import "gorm.io/gorm"

// Модель Course
type Course struct {
	gorm.Model
	Title       string `gorm:"size:255;not null;" json:"title"`
	Category    string `gorm:"size:255;not null;" json:"category"`
	Description string `gorm:"size:255;not null;" json:"description"`
	Video       string `gorm:"size:255;not null;" json:"video"`
	UserId      uint   `gorm:"not null;" json:"user_id"`      // ID пользователя-создателя курса
	TestId      uint   `gorm:"not null;" json:"test_id"`      // Внешний ключ для связи с Test
	Test        Test   `gorm:"foreignKey:TestId" json:"test"` // Связь с Test через внешний ключ TestId
}
