package models

import "gorm.io/gorm"

// Модель Test
type Test struct {
	gorm.Model
	CourseID *uint  `gorm:"null;" json:"course_id"` // Внешний ключ для связи с Course, теперь указано как указатель
	Title    string `gorm:"size:255;not null;" json:"title"`
	Tasks    []Task `gorm:"foreignKey:TestID;constraint:OnDelete:CASCADE;" json:"tasks"` // Связь с Task
}
