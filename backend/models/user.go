package models

import (
	"html"
	"strings"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	Role       string   `gorm:"size:20;default:user" json:"role"` // может быть "user" или "admin"
	FirstName  string   `gorm:"size:255;not null;" json:"first_name"`
	LastName   string   `gorm:"size:255;not null;" json:"last_name"`
	Patronymic string   `gorm:"size:255;not null;" json:"patronymic"`
	Email      string   `gorm:"size:255;not null;unique" json:"email"`
	Password   string   `gorm:"size:255;not null;" json:"password"`
	City       string   `gorm:"size:255;not null;" json:"city"`
	Birthday   string   `gorm:"size:255;not null;" json:"birthday"`
	Courses    []Course `gorm:"foreignKey:UserId" json:"courses"` // Связь с курсами
	IsBlocked  bool     `gorm:"default:false" json:"is_blocked"`
}

func (u *User) HashPassword() error {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(u.Password), bcrypt.DefaultCost) // Хеширование пароля

	if err != nil {
		return err
	}

	u.FirstName = html.EscapeString(strings.TrimSpace(u.FirstName))
	u.LastName = html.EscapeString(strings.TrimSpace(u.LastName))
	u.Patronymic = html.EscapeString(strings.TrimSpace(u.Patronymic))
	u.Email = html.EscapeString(strings.TrimSpace(u.Email))
	u.Password = string(hashedPassword)
	u.City = html.EscapeString(strings.TrimSpace(u.City))
	u.Birthday = html.EscapeString(strings.TrimSpace(u.Birthday))

	return nil
}

func (u *User) VerifyPassword(password string) error {
	return bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(password)) // Сравнение пароля с хешем
}
