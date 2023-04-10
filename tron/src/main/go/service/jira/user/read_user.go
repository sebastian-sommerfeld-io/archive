package user

import (
	"encoding/json"
	"errors"
	"io"
	"log"
	"net/http"

	"github.com/sebastian-sommerfeld-io/tron/model"
)

// ReadJiraUser reads a single User from a Jira instance.
func ReadJiraUser(config model.TronConfig, username string) (model.JiraUser, error) {

	endpoint := "/rest/api/2/user?username=" + username
	url := config.BaseURL + endpoint
	method := "GET"

	client := &http.Client{}
	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		return errorObjects(err)
	}

	req.Header.Add("Content-Type", "application/json")
	req.SetBasicAuth(config.Username, config.Password)

	res, err := client.Do(req)
	if err != nil {
		return errorObjects(err)
	}
	defer func() {
		err := res.Body.Close()
		if err != nil {
			log.Fatal(err)
		}
	}()

	if res.StatusCode == 401 {
		return errorObjects(errors.New("must have permission to access this resource"))
	}

	body, err := io.ReadAll(res.Body)
	if err != nil {
		return errorObjects(err)
	}

	result := &model.JiraUser{}
	if err := json.Unmarshal(body, result); err != nil {
		return errorObjects(err)
	}

	return *result, nil
}

func errorObjects(err error) (model.JiraUser, error) {
	return model.JiraUser{}, err
}
