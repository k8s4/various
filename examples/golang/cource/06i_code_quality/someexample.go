// Package someexample -.
package someexample

// Person -.
type Person struct {
	Name string
	Age  int
}

// GetName blah.
func (p Person) GetName() string {
	return p.Name
}

// Avatar struct -.
type Avatar struct {
	URL  string
	Size int64
}

// Client -.
type Client struct {
	ID   int64
	Img  Avatar
	Name string
	Age  int64
}

// HasAvatar -.
func (c *Client) HasAvatar() bool {
	return c.Img.URL != ""
}

// UpdateAvatar -.
func (c *Client) UpdateAvatar() {
	c.Img.URL = "new_url"
}

// GetName -.
func (c *Client) GetName() string {
	return c.Name
}

// NewClient -.
func NewClient(name string, age int, img Avatar) *Client {
	return &Client{
		ID:   7,
		Name: name,
		Age:  int64(age),
		Img:  img,
	}
}
