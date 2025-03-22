package models

type Task struct {
	Questions string `gorm:"size:255;not null;" json:"questions"`
	Answer    string `gorm:"size:255;not null;" json:"answer"`
}
