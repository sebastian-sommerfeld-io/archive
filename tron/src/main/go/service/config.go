package service

import (
	"log"
	"os"

	"github.com/sebastian-sommerfeld-io/tron/model"
	"gopkg.in/yaml.v3"
)

// ReadConfig reads the `tron.yml` config file.
func ReadConfig() model.TronConfig {
	buf, err := os.ReadFile("tron.yml")
	if err != nil {
		log.Fatal(err)
	}

	data := &model.TronConfig{}
	err = yaml.Unmarshal(buf, data)
	if err != nil {
		log.Fatal(err)
	}

	return *data
}
