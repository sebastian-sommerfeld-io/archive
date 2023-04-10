package commands

import (
	"fmt"
	"log"

	"github.com/sebastian-sommerfeld-io/tron/model"
	"github.com/sebastian-sommerfeld-io/tron/service"
	"github.com/sebastian-sommerfeld-io/tron/service/jira/user"
	"github.com/spf13/cobra"
)

const (
	// FlagUser contains the username
	FlagUsername string = "username"
)

// AddFlags adds a set of flags to the given command.
func addFlags(cmd *cobra.Command) {
	cmd.Flags().String(FlagUsername, "", "The username to search for")
	err := cmd.MarkFlagRequired(FlagUsername)
	if err != nil {
		log.Fatal(err)
	}
}

func getUsernameValue(cmd *cobra.Command) string {
	value, err := cmd.Flags().GetString(FlagUsername)
	if err != nil {
		log.Fatal(err)
	}
	return value
}

// NewCmdUser initializes the `tron user` command.
func NewCmdUser() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "user",
		Short: "Interact with a Jira instance and get Jira user information.",
		Long:  "Interact with a Jira instance and count users or access information about a Jira user.",
		Args:  cobra.ExactArgs(0),
	}

	return cmd
}

// NewCmdUser initializes the `tron user list-projects` command.
func NewCmdUserRead() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "read",
		Short: "Read a user from a Jira Instance.",
		Long:  "Read a user from a Jira Instance based on the username.",
		Args:  cobra.ExactArgs(0),

		Run: func(cmd *cobra.Command, args []string) {
			username := getUsernameValue(cmd)
			jiraUser := readUser(service.ReadConfig(), username)
			if (jiraUser == model.JiraUser{}) {
				log.Fatal("no user found for username " + username)
			}
			fmt.Println(jiraUser)
		},
	}

	addFlags(cmd)

	return cmd
}

func readUser(config model.TronConfig, username string) model.JiraUser {
	jiraUser, err := user.ReadJiraUser(config, username)
	if err != nil {
		log.Fatal(err)
	}
	return jiraUser
}

// NewCmdUser initializes the `tron user list-projects` command.
func NewCmdUserExists() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "exists",
		Short: "Check if a Jira user exists.",
		Long:  "Check if a Jira user exists.",
		Args:  cobra.ExactArgs(0),

		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println(userExists(service.ReadConfig(), getUsernameValue(cmd)))
		},
	}

	addFlags(cmd)

	return cmd
}

func userExists(config model.TronConfig, username string) bool {
	return readUser(config, username) != model.JiraUser{}
}

// NewCmdUser initializes the `tron user list-projects` command.
func NewCmdUserListProjects() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-projects",
		Short: "List all projects a user is assigned to.",
		Long:  "List all projects a user is assigned to (either directly or through group memberships).",
		Args:  cobra.ExactArgs(0),

		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println(listProjects(service.ReadConfig(), getUsernameValue(cmd)))
		},
	}

	addFlags(cmd)

	return cmd
}

func listProjects(config model.TronConfig, username string) string {
	if !userExists(config, username) {
		log.Fatal("no user found for username " + username)
	}

	return "return real data here"
}
