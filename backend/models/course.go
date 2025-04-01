package models

import "gorm.io/gorm"

// Модель Course
type Course struct {
	gorm.Model
	Title       string `gorm:"size:255;not null;" json:"title"`
	Category    string `gorm:"size:255;not null;" json:"category"`
	Description string `gorm:"size:255;not null;" json:"description"`
	Video       string `gorm:"size:255;not null;" json:"video"`
	UserId      uint   `gorm:"not null;" json:"user_id"`
	TestId      *uint  `json:"test_id"` // Nullable поле
	Test        *Test  `gorm:"foreignKey:TestId;constraint:OnUpdate:CASCADE,OnDelete:SET NULL;" json:"test"`
}
