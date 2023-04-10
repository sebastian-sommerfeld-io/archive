package model

// JiraLicense represents a license object as returned from the Jira Rest API.
type JiraLicense struct {
	Valid                bool   `json:"valid"`
	Evaluation           bool   `json:"evaluation"`
	MaximumNumberOfUsers int    `json:"maximumNumberOfUsers"`
	LicenseType          string `json:"licenseType"`
	CreationDateString   string `json:"creationDateString"`
	ExpiryDate           int    `json:"expiryDate"`
	ExpiryDateString     string `json:"expiryDateString"`
	OrganizationName     string `json:"organizationName"`
	DataCenter           bool   `json:"dataCenter"`
	Subscription         bool   `json:"subscription"`
	RawLicense           string `json:"rawLicense"`
	Expired              bool   `json:"expired"`
	SEN                  string `json:"SEN"`
	Enterprise           bool   `json:"enterprise"`
	Active               bool   `json:"active"`
	AutoRenewal          bool   `json:"autoRenewal"`
}
