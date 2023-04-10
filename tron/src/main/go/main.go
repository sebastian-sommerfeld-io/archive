package main

import (
	"log"

	"github.com/sebastian-sommerfeld-io/tron/commands"
)

func init() {
	log.SetPrefix("[tron] ")
}

func main() {
	err := commands.Execute()

	if err != nil {
		log.Fatal(err)
	}
}
