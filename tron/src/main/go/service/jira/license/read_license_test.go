package license

import (
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/sebastian-sommerfeld-io/tron/model"
	"github.com/stretchr/testify/assert"
)

func Test_ShouldGetLicense(t *testing.T) {
	licenseJson := `{"valid":true,"evaluation":true,"maximumNumberOfUsers":-1,"licenseType":"Commercial","creationDateString":"14/Feb/23","expiryDate":1678971600000,"expiryDateString":"16/Mar/23","organizationName":"sebastian@sommerfeld.io","dataCenter":true,"subscription":true,"rawLicense":"THE_ACTUAL_LICENSE","expired":false,"SEN":"SEN-L19188898","enterprise":false,"active":true,"autoRenewal":false}`

	testCases := []struct {
		name             string
		server           *httptest.Server
		expectedResponse *model.JiraLicense
		expectedErr      error
	}{
		{
			name: "ShouldGetLicense",
			server: httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				r.SetBasicAuth("admin", "admin")
				w.WriteHeader(http.StatusOK)
				_, err := w.Write([]byte(licenseJson))

				assert.Nil(t, err)
				if err != nil {
					t.Fatal(err)
				}
			})),
			expectedResponse: &model.JiraLicense{
				Valid:                true,
				Evaluation:           true,
				MaximumNumberOfUsers: -1,
				LicenseType:          "Commercial",
				CreationDateString:   "14/Feb/23",
				ExpiryDate:           1678971600000,
				ExpiryDateString:     "16/Mar/23",
				OrganizationName:     "sebastian@sommerfeld.io",
				DataCenter:           true,
				Subscription:         true,
				RawLicense:           "THE_ACTUAL_LICENSE",
				Expired:              false,
				SEN:                  "SEN-L19188898",
				Enterprise:           false,
				Active:               true,
				AutoRenewal:          false,
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
			got, err := ReadJiraLicense(config)

			assert.Nil(t, err)
			assert.NotNil(t, got)
			assert.Equal(t, testCase.expectedResponse.SEN, got.SEN)
			assert.Equal(t, testCase.expectedResponse.RawLicense, got.RawLicense)
			assert.Equal(t, testCase.expectedResponse.ExpiryDate, got.ExpiryDate)
		})
	}
}

func Test_ShouldGetError(t *testing.T) {
	testCases := []struct {
		name             string
		server           *httptest.Server
		expectedResponse *model.JiraLicense
		expectedErr      error
	}{
		{
			name: "ShouldGetUnauthorizedError",
			server: httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				r.SetBasicAuth("dummy", "dummy")
				w.WriteHeader(http.StatusUnauthorized)
			})),
			expectedResponse: &model.JiraLicense{},
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
			got, err := ReadJiraLicense(config)

			assert.NotNil(t, err)
			assert.EqualErrorf(t, err, testCase.expectedErr.Error(), "Error should be: %v, got: %v", testCase.expectedErr.Error(), err)
			assert.Equal(t, model.JiraLicense{}, got)
		})
	}
}
