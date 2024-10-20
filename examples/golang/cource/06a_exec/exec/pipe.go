package exec

import (
	"fmt"
	"log"
	"os/exec"
	"io"
	"io/ioutil"
)

func Run_with_in_pipe(c string, data string) string {
	cmd := exec.Command(c)
	stdin, err := cmd.StdinPipe()
	if err != nil {
		log.Fatal(err)
	}

	go func() {
		defer stdin.Close()
		io.WriteString(stdin, data)
	}()

	out, err := cmd.CombinedOutput()
	if err != nil {
		log.Fatal(err)
	}

	return fmt.Sprintf("%s", out)
}


func Run_with_out_pipe(c string, arg ...string) string {
	cmd := exec.Command(c, arg...)
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}

	if err := cmd.Start(); err != nil {
		log.Fatal(err)
	}

	data, err := ioutil.ReadAll(stdout)
	if err != nil {
		log.Fatal(err)
	}

	if err := cmd.Wait(); err != nil {
		log.Fatal(err)
	}

	return fmt.Sprintf("%s", string(data))
}
