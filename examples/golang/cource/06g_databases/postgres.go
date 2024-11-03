package main
// GORM
// https://github.com/jackc/pgx

import (
	"fmt"
	"context"
	"os"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/georgysavva/scany/pgxscan"
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

func PostgresScanToObject() {
	ctx := context.Background()
	db, err := pgxpool.Connect(ctx, "postgres://postgres:some@localhost:5432/postgres")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Can't connect to db: %v\n", err)
		os.Exit(1)
	}

	type User struct {
		Name string
		Rank string
		Id int
	}
	defer db.Close()

	var users []User
	pgxscan.Select(ctx, db, &users, "select * from users")
	fmt.Println(users)

	var user User
	pgxscan.Get(ctx, db, &user, "select * from users where id=$1", 2)
	fmt.Println(user)
}

func PostgresJoinQuery() {
	ctx := context.Background()
	db, err := pgxpool.Connect(ctx, "postgres://postgres:some@localhost:5432/postgres")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Can't connect to db: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	query := "SELECT users.name, users.rank, cr.brand, cr.colour, cr.license_plate "+
				"FROM users "+
				"JOIN cars cr ON users.id = cr.user_id "+
				"WHERE users.rank = $1"

	type UserCar struct {
		Name string
		Rank string
		Brand string
		Colour string
		LicensePlate string
	}
	var carBounds []UserCar

	pgxscan.Select(ctx, db, &carBounds, query, "Manager")
	fmt.Println(carBounds)
}

func PostgresAddCar(userId int, colour string, brand string, licensePlate string) {
	ctx := context.Background()
	conn, err := pgx.Connect(ctx, "postgres://postgres:some@localhost:5432/postgres")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Can't connect to db: %v\n", err)
		os.Exit(1)
	}
	defer conn.Close(ctx)

	_, err = conn.Exec(ctx, "INSERT INTO cars(user_id, colour, brand, license_plate) "+
							"VALUES ($1,$2,$3,$4)", userId, colour, brand, licensePlate)
	fmt.Println(err)
}

func main() {
	fmt.Println(PostgresSimpleQuery())
	PostgresScanToObject()
	PostgresJoinQuery()
//	PostgresAddCar(1,"SomeShit","Kaiyi","A666G4")
}
