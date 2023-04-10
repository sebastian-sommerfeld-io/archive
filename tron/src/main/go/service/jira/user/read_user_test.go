package user

import (
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/sebastian-sommerfeld-io/tron/model"
	"github.com/stretchr/testify/assert"
)

func Test_ShouldGetUser(t *testing.T) {
	// When Jira is updated, get the correct Json from postman and paste here
	expectedUserJson := `{"self":"http://localhost:8080/rest/api/2/user?username=cloud","key":"JIRAUSER10001","name":"cloud","emailAddress":"cloud.strife@localhost","avatarUrls":{"48x48":"https://www.gravatar.com/avatar/50379dac062deb53730cbf343af03722?d=mm&s=48","24x24":"https://www.gravatar.com/avatar/50379dac062deb53730cbf343af03722?d=mm&s=24","16x16":"https://www.gravatar.com/avatar/50379dac062deb53730cbf343af03722?d=mm&s=16","32x32":"https://www.gravatar.com/avatar/50379dac062deb53730cbf343af03722?d=mm&s=32"},"displayName":"Cloud Strife","active":true,"deleted":false,"timeZone":"Europe/Berlin","locale":"en_US","groups":{"size":2,"items":[]},"applicationRoles":{"size":1,"items":[]},"expand":"groups,applicationRoles"}`

	testCases := []struct {
		name             string
		server           *httptest.Server
		expectedResponse *model.JiraUser
		expectedErr      error
	}{
		{
			name: "ShouldGetUser",
			server: httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				r.SetBasicAuth("admin", "admin")
				w.WriteHeader(http.StatusOK)
				_, err := w.Write([]byte(expectedUserJson))

				assert.Nil(t, err)
				if err != nil {
					t.Fatal(err)
				}
			})),
			expectedResponse: &model.JiraUser{
				Id:          "JIRAUSER10001",
				DisplayName: "Cloud Strife",
				Username:    "cloud",
				Email:       "cloud.strife@localhost",
				Active:      true,
				Deleted:     false,
			},
			expectedErr: nil,
		},
	}

	for _, testCase := range testCases {
		t.Run(testCase.name, func(t *testing.T) {
			config := model.TronConfig{
				BaseURL:  testCase.server.URL,
				Username: "admin",
				Password: "admin",
			}

			defer testCase.server.Close()
			got, err := ReadJiraUser(config, "cloud")

			assert.Nil(t, err)
			assert.NotNil(t, got)
			assert.Equal(t, testCase.expectedResponse.Id, got.Id)
			assert.Equal(t, testCase.expectedResponse.DisplayName, got.DisplayName)
			assert.Equal(t, testCase.expectedResponse.Username, got.Username)
			assert.Equal(t, testCase.expectedResponse.Email, got.Email)
			assert.Equal(t, testCase.expectedResponse.Active, got.Active)
			assert.Equal(t, testCase.expectedResponse.Deleted, got.Deleted)
		})
	}
}

func Test_ShouldGetError(t *testing.T) {
	testCases := []struct {
		name             string
		server           *httptest.Server
		expectedResponse *model.JiraUser
		expectedErr      error
	}{
		{
			name: "ShouldGetUnauthorizedError",
			server: httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				r.SetBasicAuth("dummy", "dummy")
				w.WriteHeader(http.StatusUnauthorized)
			})),
			expectedResponse: &model.JiraUser{},
			expectedErr:      errors.New("must have permission to access this resource"),
		},
	}

	for _, testCase := range testCases {
		t.Run(testCase.name, func(t *testing.T) {
			config := model.TronConfig{
				BaseURL:  testCase.server.URL,
				Username: "dummy",
				Password: "dummy",
			}
			defer testCase.server.Close()
			got, err := ReadJiraUser(config, "cloud")

			assert.NotNil(t, err)
			assert.EqualErrorf(t, err, testCase.expectedErr.Error(), "Error should be: %v, got: %v", testCase.expectedErr.Error(), err)
			assert.Equal(t, model.JiraUser{}, got)
		})
	}
}
