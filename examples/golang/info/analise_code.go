package main

import (
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"bufio"
	"os"
)

func main() {
	var data string

	if len(os.Args) < 2 {
		fmt.Println("Usage: analize <filename>")
		return
 	}

	filePath := os.Args[1]

	file, err := os.Open(filePath)
	if err != nil {
		fmt.Println("Can't open file:", err)
		return
	}
 	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		data += scanner.Text() + "\n"
	}

	if err := scanner.Err(); err != nil {
		fmt.Println("Can't scan file as text:", err)
		return
	}

// 	fmt.Println("Data from file:", data)
	inspectStructFromFile(data)
}



func inspectStructFromFile(src string) {
	fset := token.NewFileSet()
	f, err := parser.ParseFile(fset, "", src, 0)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	ast.Inspect(f, func(n ast.Node) bool {
		switch x := n.(type) {
		case *ast.TypeSpec:
		if _, ok := x.Type.(*ast.StructType); ok {
			fmt.Printf("Struct: %s\n", x.Name.Name)
		}
		case *ast.StructType:
			for _, field := range x.Fields.List {
				fmt.Printf("Field: %s\n", field.Names[0].Name)
			}
		}
		return true
	})
}
