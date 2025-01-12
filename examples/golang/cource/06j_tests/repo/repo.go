package repo

import (
	"06j_tests/entity"
	"database/sql"
)

type Repository struct {
	db *sql.DB
}

func NewRepo(db *sql.DB) *Repository {
	return &Repository{db: db}
}

func (r *Repository) GetByID(id int) (entity.Item, error) {
	rows, err := r.db.Query("SELECT id, title FROM items WHERE id = ", id)
	item := entity.Item{}
	if err != nil {
		return item, err
	}
	defer rows.Close()

	for rows.Next() {
		err = rows.Scan(&item.ID, &item.Title)
		if err != nil {
			return item, err
		}
	}
	return item, err
}
