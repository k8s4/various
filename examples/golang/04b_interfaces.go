// Interfaces, Duck typing, polymorphism
// Empty interfaces
//
//
// rintime.GC()


package main
import "fmt"


type Caller interface {
	Call(number int) error
}

type Sender interface {
	Send(msg string) error
}

type IPhone interface {
	Caller
	Sender
	//MyFunc()
}


type Email struct {
	Address string
}

func (e *Email) Send(msg string) error {
	fmt.Printf("Message \"%v\" sent to %v \n", msg, e.Address)
	return nil
}

type Phone struct {
	Number int
	Balance int
}

func (p *Phone) Send(msg string) error {
	fmt.Printf("SMS \"%v\" sent from phone number %v \n", msg, p.Number)
	p.Balance = p.Balance - 10
	return nil
}

func Notify(s Sender) {
	err := s.Send("Notify message")
	if err != nil {
		fmt.Println(err)
		return
	}
	switch s.(type) {
	case *Email:
		fmt.Println("Sucksess to email")
	case *Phone:
		phone := s.(*Phone)
		fmt.Println(phone.Balance)
	}
}

func main() {
	email := &Email{"somdick3241@contoso.com"}
	Notify(email)

	phone := &Phone{100500, 300}
	Notify(phone)
}


