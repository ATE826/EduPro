package models

import "gorm.io/gorm"

// Модель Test
// Модель Test
type Test struct {
	gorm.Model
	CourseID uint   `gorm:"not null;" json:"course_id"` // Внешний ключ для связи с Course
	Title    string `gorm:"size:255;not null;" json:"title"`
	Task     []Task `gorm:"foreignkey:TestID;" json:"task"`
	// Дополнительные поля для Test
}
