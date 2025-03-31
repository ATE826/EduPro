package models

import "gorm.io/gorm"

// Модель Test
type Test struct {
	gorm.Model
	Title    string `gorm:"size:255;not null;" json:"title"`
	CourseID uint   `gorm:"not null;" json:"course_id"`                                  // Внешний ключ для связи с Course
	Course   Course `gorm:"foreignKey:CourseID" json:"course"`                           // Связь с Course
	Tasks    []Task `gorm:"foreignKey:TestID;constraint:OnDelete:CASCADE;" json:"tasks"` // Связь с Task
}
