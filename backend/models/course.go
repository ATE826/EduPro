package models

import "gorm.io/gorm"

type Course struct {
	gorm.Model
	Title       string `gorm:"size:255;not null;" json:"title"`
	Category    string `gorm:"size:255;not null;" json:"category"`
	Description string `gorm:"size:255;not null;" json:"description"`
	Video       string `gorm:"size:255;not null;" json:"video"`
	UserId      uint   `gorm:"size:255;not null;" json:"user_id"` // Id пользователя-создателя курса
	Test        Test   `gorm:"one2one:course_test;" json:"test"`
}
