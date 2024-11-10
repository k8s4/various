package processors

import (
	"errors"
)

type UsersProcessor struct {
	storage *db.UsersStorage
}

func NewUsersProcessor(storage *db.UsersStorage) *UsersProcessor {
	processor := new(UsersProcessor)
	processor.storage = storage
	return processor
}

func (processor *UsersProcessor) CreateUser(user models.User) error {
	if user.Name == "" {
		return errors.New("Name should not be empty.")
	}
	return processor.storage.CreateUser(user)
}

func (processor *UsersProcessor) FindUser(id int64) (models.User, error) {
	user := processor.storage.GetUserById(id)
	if user.Id != id {
		return user, errors.New("User not found.")
	}

	return user, nil
}

func (processor *UsersProcessor) ListUsers(nameFilter string) ([]models.User, error) {
	return processor.storage.GetUserList(nameFilter), nil
}
