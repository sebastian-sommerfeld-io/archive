package model

// TronConfig represents the global configuration for this app. The config holds all information
// to connect to a Jira instance.
type TronConfig struct {
	BaseURL  string `yaml:"baseUrl"`
	Username string `yaml:"username"`
	Password string `yaml:"password"`
}
