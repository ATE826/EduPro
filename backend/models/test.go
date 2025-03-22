package models

import "gorm.io/gorm"

type Test struct {
	gorm.Model
	Task []Task `gorm:"many2one:test_task;" json:"task"`
}
