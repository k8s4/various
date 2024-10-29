package main

import (
	"fmt"
	"log"
	"io/ioutil"
	"gopkg.in/yaml.v3"
	"strings"
)

type BuildConf struct {
	Definitions	map[string]interface{}	`yaml:"definitions"`
	Pipelines	map[string]interface{}	`yaml:"pipelines"`
}

type Shon struct {
	Some	int64	`yaml:"some"`
	Time	int64	`yaml:"time"`
}

type SlicesTags []string

func (tags *SlicesTags) UnmarshalYAML(value *yaml.Node) error {
	if value != nil {
		*tags = strings.Split(value.Value, ",")
	}
	return nil
}

type Messages struct {
	Tags SlicesTags `yaml:"tags"`
}

type Subs struct {
	Messages Messages `yaml:"messages"`
}

func ParseYamlWithCustomStruct() {
	config := &Subs{}

	file, err := ioutil.ReadFile("examples/custom.yaml")
	if err != nil {
		log.Printf("Read file err: %v", err)
	}
	err = yaml.Unmarshal(file, config)
	if err != nil {
		log.Fatalf("Unmarshal err: %v", err)
	}
	fmt.Println(*config)
}

func GetShon() {
	shon := &Shon{}

	file, err := ioutil.ReadFile("examples/example.yaml")
	if err != nil {
		log.Printf("Read file err: %v", err)
	}
	err = yaml.Unmarshal(file, shon)
	if err != nil {
		log.Fatalf("Unmarshal err: %v", err)
	}

	fmt.Println(*shon)
}

func ReadAnchoredYaml() {
	conf := &BuildConf{}

	file, err := ioutil.ReadFile("examples/anchor.yaml")
	if err != nil {
		log.Printf("Read file err: %v", err)
	}
	err = yaml.Unmarshal(file, conf)
	if err != nil {
		log.Fatalf("Unmarshal err: %v", err)
	}

	fmt.Println("Second, Ancor: ", conf)
}

func main() {
	GetShon()
	ReadAnchoredYaml()
	ParseYamlWithCustomStruct()
}
