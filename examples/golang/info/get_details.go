package main

import (
	"fmt"
	"reflect"
)

type Some struct {
	Name string
	Age int
	Gender string
}

func (s Some) GetPegi() int {
        switch {
                case s.Age <= 7:
                        return 3
                case s.Age <= 12:
                        return 7
                case s.Age <= 16:
                        return 12
                case s.Age <= 18:
                        return 16
                default:
                        return 18
        }
}

func main() {
	man := Some{Name: "Peter", Age: 22, Gender: "male"}
	girl := Some{Name: "Agata", Age: 14, Gender: "female"}

	fmt.Printf("Some: %v, with pegi: %v\n", reflect.ValueOf(man), man.GetPegi()) 
	fmt.Printf("Some: %v, with pegi: %v\n", reflect.ValueOf(girl), girl.GetPegi()) 
	fmt.Printf("Type of: %v\n", reflect.ValueOf(man).Kind()) 
	fmt.Printf("Numbers fields: %v\n", reflect.TypeOf(man).NumField()) 
	fmt.Printf("Numbers methods: %v\n", reflect.TypeOf(man).NumMethod()) 

	inspectStruct(man)
}

func inspectStruct(s interface{}) {
    t := reflect.TypeOf(s)
    
    fmt.Printf("Structure: %s\n", t.Name())
    fmt.Println("Fields:")
    for i := 0; i < t.NumField(); i++ {
        field := t.Field(i)
        fmt.Printf("  %s: %s\n", field.Name, field.Type)
    }
    
    fmt.Println("Methods:")
    for i := 0; i < t.NumMethod(); i++ {
        method := t.Method(i)
        fmt.Printf("  %s: %s\n", method.Name, method.Type)
    }
    fmt.Println()
}

