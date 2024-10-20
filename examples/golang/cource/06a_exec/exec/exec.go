package exec

import (
	"fmt"
	"log"
	"os/exec"
	"strings"
	"bytes"
)

func Run_simple(c string) string {
	cmd, err := exec.Command(c).Output()
//	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}
	return string(cmd)
}

func Run_some_std_inout(s string) string {
	cmd := exec.Command("tr", "a-z", "A-Z")

	cmd.Stdin = strings.NewReader(s)
	var out bytes.Buffer
	cmd.Stdout = &out

	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	return fmt.Sprintf("Converted string: %q", out.String())
}
