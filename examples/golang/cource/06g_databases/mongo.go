package main

import (
	"fmt"
	"time"
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Number struct {
	Name string `bson:"name"`
	Value string `bson:"value"`
//	Item string `bson:"item"`
//	Price string `bson:"price"`
}

func MongoInsert() {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://root:some@localhost:27017"))
	defer func(){
		if err = client.Disconnect(ctx); err != nil{
			panic(err)
		}
	}()

	collection := client.Database("db").Collection("numbers")
	res, err := collection.InsertOne(ctx, bson.D{{"name", "pi"}, {"value", "in the water"}})
	id := res.InsertedID

	fmt.Println(id)
}

func MongoInsertObject() {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://root:some@localhost:27017"))

	defer func(){
		if err = client.Disconnect(ctx); err != nil{
			panic(err)
		}
	}()
	collection := client.Database("db").Collection("numbers")

	num := Number{
		Name: "Earth Diameter",
		Value: "12742",
	}

	res, err := collection.InsertOne(ctx, num)
	id := res.InsertedID

	fmt.Println(id)
}

func MongoGetList() {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://root:some@localhost:27017"))

	defer func(){
		if err = client.Disconnect(ctx); err != nil{
			panic(err)
		}
	}()
	collection := client.Database("db").Collection("numbers")

	var num Number

	res, err := collection.Find(ctx, bson.D{{}})
	for res.Next(ctx) {
		res.Decode(&num)
		elements, _ := res.Current.Elements()
		fmt.Println(elements[0])
		fmt.Println(num)
	}

}

func MongoGetOne() {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	client, err := mongo.Connect(ctx, options.Client().ApplyURI("mongodb://root:some@localhost:27017"))

	defer func(){
		if err = client.Disconnect(ctx); err != nil{
			panic(err)
		}
	}()
	collection := client.Database("db").Collection("numbers")

	var num Number

	res := collection.FindOne(ctx, bson.D{{"name", "pi"}})
	res.Decode(&num)
	fmt.Println(num)
}

func main() {
	MongoInsert()
	MongoInsertObject()
	MongoGetList()
	MongoGetOne()
}
