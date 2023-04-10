package commands

import (
	"github.com/spf13/cobra"
)

const (
	// FlagBaseUrl contains the name of a mandatory flag
	FlagBaseUrl string = "baseUrl"

	// FlagUser contains the name of a mandatory flag
	FlagUser string = "user"

	// FlagPass contains the name of a mandatory flag
	FlagPass string = "pass"
)

// NewCmdRoot initializes the `tron` root command.
func NewCmdRoot() *cobra.Command {
	cmd := &cobra.Command{
		Use:     "tron",
		Version: appVersion(),
		Short:   "Tron is a command line interface to access Jira and automate recurring tasks.",
		Long:    "Tron interacts with a Jira instance through the command line. The app wraps Jira Rest API calls into simple commands.",
		Args:    cobra.ExactArgs(0),
	}

	return cmd
}

var rootCmd *cobra.Command

func init() {
	rootCmd = NewCmdRoot()

	configCmd := NewCmdConfig()
	rootCmd.AddCommand(configCmd)
	configCmd.AddCommand(NewCmdConfigView())

	userCmd := NewCmdUser()
	rootCmd.AddCommand(userCmd)
	userCmd.AddCommand(NewCmdUserRead())
	userCmd.AddCommand(NewCmdUserExists())
	userCmd.AddCommand(NewCmdUserListProjects())

	rootCmd.AddCommand(NewCmdLicense())

	rootCmd.CompletionOptions.HiddenDefaultCmd = true
}

// Execute acts as the entrypoint for the command line interface.
func Execute() error {
	return rootCmd.Execute()
}

func appVersion() string {
	return "tron-work-in-progress"
}
