package service

import (
	"06j_tests/entity"
	"testing"

	"github.com/golang/mock/gomock"
)

func TestGetItemTitleByID(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	repo := NewMockItemRepoInterface(ctrl)
	srv := NewItemService(repo)

	expect := entity.Item{
		ID:    10,
		Title: "TestTitle",
	}

	repo.EXPECT().GetByID(10).Return(expect, nil)

	res, err := srv.GetItemTitleByID(10)
	if err != nil {
		t.Errorf("failed to get title: %s", err)
		return
	}

	if res != expect.Title {
		t.Errorf("result not match, want %s, get %s", expect.Title, res)
		return
	}
}
