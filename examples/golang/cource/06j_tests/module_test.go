package main

import (
	"testing"
)

func TestFibZero(t *testing.T) {
	res := fib(0)
	if res != 0 {
		t.Fatal("Zero test: return must be 0")
	}
}

func TestFibOne(t *testing.T) {
	res := fib(1)
	if res != 1 {
		t.Fatal("One test: return must be 1")
	}
}

func TestFibNum(t *testing.T) {
	res := fib(7)
	if res != 13 {
		t.Fatal("Serven test: return must be 13")
	}
}
