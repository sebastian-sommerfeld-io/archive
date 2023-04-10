package license

import (
	"encoding/json"
	"errors"
	"io"
	"log"
	"net/http"

	"github.com/sebastian-sommerfeld-io/tron/model"
)

// ReadJiraLicense reads the license used to allow Jira Software to work. The license
// is used for Jira itself, not for any plugin.
func ReadJiraLicense(config model.TronConfig) (model.JiraLicense, error) {
	endpoint := "/rest/plugins/applications/1.0/installed/jira-software/license"
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

	result := &model.JiraLicense{}
	if err := json.Unmarshal(body, result); err != nil {
		return errorObjects(err)
	}

	return *result, nil
}

func errorObjects(err error) (model.JiraLicense, error) {
	return model.JiraLicense{}, err
}
