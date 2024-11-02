package main
// GORM
// https://github.com/jackc/pgx

import (
	"fmt"
	"context"
	"os"
	"github.com/jackc/pgx/v4"
//	"github.com/jackc/pgx/v4/pgxpool"
//	"github.com/georgysavva/scany/pgxscan"
)

func PostgresSimpleQuery() (name string, position string) {
	var id int64
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, "postgres://postgres:some@localhost:5432/postgres")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Can't connect to db: %v\n", err)
		os.Exit(1)
	}
	defer conn.Close(ctx)

	err = conn.QueryRow(ctx, "select * from users where id=$1", 2).Scan(&id, &name, &position)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Query faild: %v\n", err)
		os.Exit(1)
	}
	return name, position
}

func main() {
	fmt.Println(PostgresSimpleQuery())
}
