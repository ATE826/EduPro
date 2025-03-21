package models

import "gorm.io/gorm"

type Course struct {
	gorm.Model
	Title       string `gorm:"size:255;not null;" json:"title"`
	Category    string `gorm:"size:255;not null;" json:"category"`
	Description string `gorm:"size:255;not null;" json:"description"`
	Video       string `gorm:"size:255;not null;" json:"video"`
	Test        Test   `gorm:"one2one:course_test;" json:"test"`
}

type Test struct {
	gorm.Model
	Task []Task `gorm:"one2one:test_task;" json:"task"`
}

type Task struct {
	Questions string `gorm:"size:255;not null;" json:"questions"`
	Answer    string `gorm:"size:255;not null;" json:"answer"`
}
