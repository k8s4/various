package db

import (
	"context"
	"fmt"

	"golang/cource/06h_http/internals/app/models"

	"github.com/georgysavva/scany/pgxscan"
	"github.com/jackc/pgx/v4/pgxpool"
	log "github.com/sirupsen/logrus"
)

type UserStorage struct {
	databasePool *pgxpool.Pool
}

func NewUsersStorage(pool *pgxpool.Pool) *UserStorage {
	storage := new(UserStorage)
	storage.databasePool = pool
	return storage
}

func (storage *UserStorage) GetUsersList(nameFilter string) []models.User {
	query := "SELECT id, name, rank FROM users"
	args := make([]interface{}, 0)
	if nameFilter != "" {
		query += " WHERE name LIKE $1"
		args = append(args, fmt.Sprintf("%%%v%%", nameFilter))
	}

	var result []models.User

	err := pgxscan.Select(context.Background(), storage.databasePool, &result, query, args...)
	if err != nil {
		log.Errorln(err)
	}

	return result
}

func (storage *UserStorage) GetUserById(id int64) models.User {
	query := "SELECT id, name, rank FROM users WHERE id = $1"

	var result models.User

	err := pgxscan.Get(context.Background(), storage.databasePool, &result, query, id)
	if err != nil {
		log.Errorln(err)
	}

	return result
}

func (storage *UserStorage) CreateUser(user models.User) error {
	query := "INSERT INTO users(name, rank) VALUES ($1, $2)"

	_, err := storage.databasePool.Exec(context.Background(), query, user.Name, user.Rank)
	if err != nil {
		log.Errorln(err)
		return err
	}

	return nil
}
