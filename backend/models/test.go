package models

import "gorm.io/gorm"

// Модель Test
type Test struct {
	gorm.Model
	CourseID *uint  `gorm:"not null;foreignKey:TestId;constraint:OnDelete:CASCADE;" json:"course_id"` // Внешний ключ для связи с Course, теперь указано как указатель
	Title    string `gorm:"size:255;not null;" json:"title"`
	Tasks    []Task `gorm:"foreignKey:TestID;constraint:OnDelete:CASCADE;" json:"tasks"` // Указываем внешний ключ
}
