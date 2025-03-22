package models

import "gorm.io/gorm"

type Test struct {
	gorm.Model
	Task []Task `gorm:"one2one:test_task;" json:"task"`
}
