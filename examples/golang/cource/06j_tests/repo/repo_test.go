package repo

import (
	"06j_tests/entity"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
)

func TestGetByIDSuccess(t *testing.T) {
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatal("mock fail", err)
	}
	defer db.Close()

	repo := NewRepo(db)
	rows := sqlmock.NewRows([]string{"id", "title"})
	expect := entity.Item{
		ID:    10,
		Title: "TestTitle",
	}

	rows.AddRow(expect.ID, expect.Title)

	mock.
		ExpectQuery("SELECT id, title FROM items WHERE id = ?").
		WithArgs(expect.ID).
		WillReturnRows(rows)

	item, err := repo.GetByID(10)
	if err != nil {
		t.Errorf("fail to get data: %s", err)
		return
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("expectations were not meet: %s", err)
		return
	}

	if item.ID != expect.ID && item.Title != expect.Title {
		t.Errorf("result not match, want %v, get %v", expect, item)
		return
	}
}
