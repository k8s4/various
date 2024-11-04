package main

import (
	"fmt"
//	"time"
	"github.com/gomodule/redigo/redis"
)

func RedisSimple() {
	conn, err := redis.Dial("tcp", "localhost:6379")
	if err != nil {
		panic(err)
	}
	defer conn.Close()

	_, err = conn.Do("SET", "somekey1", 42)
	if err != nil {
		fmt.Println(err)
	}
	get, _ := redis.Int(conn.Do("GET", "somekey1"))
	fmt.Printf("Somekey1: %d\n", get)
	incr, _ := redis.Int(conn.Do("INCR", "somekey1"))
	fmt.Printf("Somekey1: %d\n", incr)
//	conn.Do("EXPIRE", "somekey1", 3)
//	time.Sleep(4 * time.Second)
//	get2, _ := conn.Do("GET", "somekey1")
//	fmt.Printf("Somekey1: %d\n", get2)
}

func RedisScan() {
	conn, err := redis.Dial("tcp", "localhost:6379")
	if err != nil {
		panic(err)
	}
	defer func() {
		if err = conn.Close(); err != nil {
			panic(err)
		}
	}()

	iter := 0
	var keys []string
	for {
		if array, err := redis.Values(conn.Do("SCAN", iter)); err != nil {
			panic(err)
		} else {
			iter, _ = redis.Int(array[0], nil)
			keys, _ = redis.Strings(array[1], nil)
		}
		fmt.Println(keys)

		if iter == 0 {
			break
		}
	}
}

func RedisListType() {
	conn, err := redis.Dial("tcp", "localhost:6379")
	if err != nil {
		panic(err)
	}
	defer func() {
		if err = conn.Close(); err != nil {
			panic(err)
		}
	}()

	conn.Do("RPUSH", "somelist", "one")
	conn.Do("RPUSH", "somelist", "two")
	conn.Do("RPUSH", "somelist", "three")

	vars, _ := redis.Values(conn.Do("LRANGE", "somelist", 0, 4))
	fmt.Println(redis.String(vars[0], nil))
	fmt.Println(redis.String(vars[1], nil))
	fmt.Println(redis.String(vars[2], nil))
}

func main() {
	RedisSimple()
	RedisListType()
	RedisScan()
}
