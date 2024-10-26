package main

import (
	"fmt"
	"os"
	"encoding/json"
	"strings"
)

type RequestContent struct {
	User	string
	Message	string `json:"msg"`
}

type Request struct {
	Request RequestContent
	Author	string `json:"user"`
}

type strslice []string

func (ss *strslice) UnmarshalJSON(data []byte) error {
	var s string
	if err := json.Unmarshal(data, &s); err != nil {
		return err
	}
	*ss = strings.Split(s, ",")
	return nil
}

type RequestContentTag struct {
	User string
	Message string `json:"msg"`
	Tags strslice `json:"tags"`
}

type RequestTagged struct {
	Request RequestContentTag
	Author string `json:"user"`
}

type Dimensions struct {
	Height	int
	Width	int
}

type Bird struct {
	Species		string
	Description	string
	Dimensions Dimensions
}

func ParseJson(birdJson string) {
//	birdJson := `{"species":"pingeon","description":"Likes to perch on rocks...","dimensions":{"height": 22,"width": 41}}`
	var bird Bird
	err := json.Unmarshal([]byte(birdJson), &bird)
	if err != nil {
		panic(err)
	}
	fmt.Println(bird)
}

func ParseJsonArrays() {
	arraysJson := `["some","word","list"]`
	var nums []string

	json.Unmarshal([]byte(arraysJson), &nums)
	fmt.Println(nums)
}

func CreateJson() string {
	bird := Bird{
		Species:	"Eagle",
		Description:	"Some eagle.",
		Dimensions: Dimensions{
			Height:	120,
			Width: 60,
		},
	}
//	data, _ := json.Marshal(bird)
	data, _ := json.MarshalIndent(bird, " ", "  ")
	fmt.Println(string(data))
	return string(data)
}

func LoadAndParceJson() {
	jsonData, err := os.ReadFile("example.json")
	fmt.Println(err)
	var request Request
	fmt.Println(json.Unmarshal(jsonData, &request))
	fmt.Println(request)
}

func LoadAndParseRawMsgToMap() {
	jsonData, _ := os.ReadFile("example.json")
	var objmap map[string]interface{}
	json.Unmarshal(jsonData, &objmap)
	fmt.Println(objmap)
}

func LoadAndParseRawMsg() {
	jsonData, _ := os.ReadFile("example.json")
	var objmap map[string]json.RawMessage
	json.Unmarshal(jsonData, &objmap)
	fmt.Println(objmap)
	var internalMap map[string]string
	json.Unmarshal(objmap["request"], &internalMap)
	fmt.Println(internalMap)
}

func LoadAndParseJsonToCustomStruct() {
	jsonData, err := os.ReadFile("custom.json")
	fmt.Println(err)
	var request RequestTagged
	fmt.Println(json.Unmarshal(jsonData, &request))
	fmt.Println(request)
}

func main() {
	ParseJson(CreateJson())
	ParseJsonArrays()
	LoadAndParceJson()
	LoadAndParseRawMsgToMap()
	LoadAndParseRawMsg()
	LoadAndParseJsonToCustomStruct()
}
