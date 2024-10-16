package main

import "fmt"

type Cache[T any] struct {
	store map[string]T
}

func NewCache[T any]() *Cache[T] {
	return &Cache[T]{store: make(map[string]T)}
}

func (c *Cache[T]) Set(key string, value T) {
	c.store[key] = value
}

func (c *Cache[T]) Get(key string) (T, bool) {
	val, found := c.store[key]
	return val, found
}

func main() {
	intCache := NewCache[int]()
	intCache.Set("key1", 50)
	fmt.Println(intCache.Get("key1"))

	stringCache := NewCache[string]()
	stringCache.Set("something", "inthewater")
	fmt.Println(stringCache.Get("something"))
}
