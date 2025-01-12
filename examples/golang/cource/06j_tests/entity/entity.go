package entity

type Item struct {
	ID    int    `db:"id"`
	Title string `db:"title"`
}
