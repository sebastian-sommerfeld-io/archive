package commands

import (
	"fmt"
	"log"

	"github.com/sebastian-sommerfeld-io/tron/model"
	"github.com/sebastian-sommerfeld-io/tron/service"
	"github.com/sebastian-sommerfeld-io/tron/service/jira/license"
	"github.com/spf13/cobra"
)

// NewCmdLicense initializes the `jiracli license` command.
func NewCmdLicense() *cobra.Command {

	cmd := &cobra.Command{
		Use:   "license",
		Short: "Show license information (Jira Software, not plugins).",
		Long:  "Show license information (Jira Software, not plugins).",
		Args:  cobra.ExactArgs(0),

		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println(jiraSoftwareLicense(service.ReadConfig()))
		},
	}

	return cmd
}

func jiraSoftwareLicense(config model.TronConfig) model.JiraLicense {
	jiraLicense, err := license.ReadJiraLicense(config)
	if err != nil {
		log.Fatal(err)
	}
	return jiraLicense
}
