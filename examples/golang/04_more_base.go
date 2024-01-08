// More structures, pointers
// Scope: some started from Capital char will visible outside package.
//        var Some like Public, var some like private
// Struct in struct
//

package main

import "fmt"

type Prof struct {
	Prof_name string
	Years int8
	Grade string
}

type Avatar struct {
	URL string
	Size int64
}

type Client struct {
	ID int64
	Name string
	Age int
	IMG *Avatar
	Prof
}

func main() {
	//add pointer on memory scope into i
	i := new(int64)
	_ = i

	client := Client{}
	fmt.Printf("%#v\n", client)

	client.IMG = new(Avatar)
	//updateAvatar(&client)
	client.updateAvatar()
	fmt.Printf("%#v\n", client)
	fmt.Printf("%#v\n", client.IMG)

	updateClient(&client)
	fmt.Printf("%#v\n", client)

	fclient := Client{
			ID: 4,
			Name: "Olaf",
			Age: 56,
			//IMG: new(Avatar),
			//IMG: &Avatar{},
			IMG: &Avatar{
				URL: "some_shit_url",
				Size: 10,
			},
			Prof: Prof{
				Prof_name: "Admin",
				Years: 10,
				Grade: "F",
			},

	}
	fmt.Printf("%#v\n", fclient)
	fmt.Println(fclient.HasAvatar())


}

//func updateAvatar(client *Client) {
func (c *Client) updateAvatar() {
	//client.IMG.URL = "updated_url"
	c.IMG.URL = "updated_shit_url"
}

func (c Client) HasAvatar() bool {
	if c.IMG != nil && c.IMG.URL != "" {
		return true
	}
	return false
}

func updateClient(client *Client) {
	client.Name = "Dikker"
}

