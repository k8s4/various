package main

import (
	"fmt"
	"encoding/xml"
)

type Plant struct {
	XMLName	xml.Name	`xml:"plant"`
	Id	int		`xml:"id,attr"`
	Name	string		`xml:"name"`
	Origin	[]string	`xml:"origin"`
}

func (p Plant) String() string {
	return fmt.Sprintf("Plant id=%d, name=%s, origin=%s", p.Id, p.Name, p.Origin)
}

func CreateXML() string {
	coffee := &Plant{Id: 27, Name: "Coffee"}
	coffee.Origin = []string{"Ephiopia", "Brazil"}

	out, _ := xml.MarshalIndent(coffee, " ", "  ")
	return string(out)
}

func DecodeXML(input string) {
	var p Plant
	if err := xml.Unmarshal([]byte(input), &p); err != nil {
		panic(err)
	}
	fmt.Println(p)
}

func NestedXML() {
	tomato := &Plant{Id: 44, Name: "Tomato"}
	tomato.Origin = []string{"Mexico", "California"}

	coffee := &Plant{Id: 27, Name: "Coffee"}
	coffee.Origin = []string{"Ethiopia", "Brazil"}

	type Nesting struct {
		XMLName xml.Name	`xml:"nesting"`
		Plants	[]*Plant	`xml:"parent>child>plant"`
	}

	nesting := &Nesting{}
	nesting.Plants = []*Plant{coffee, tomato}

	out, _ := xml.MarshalIndent(nesting, " ", "  ")
	fmt.Println(string(out))
	
	res := &Nesting{}
	xml.Unmarshal(out, res)
	fmt.Println(res)
}

func main() {
	somexml := CreateXML()
	fmt.Println(somexml)
	DecodeXML(somexml)
	NestedXML()
}
