package commands

import (
	"fmt"

	"github.com/sebastian-sommerfeld-io/tron/service"
	"github.com/spf13/cobra"
)

// NewCmdConfig initializes the `tron config` command.
func NewCmdConfig() *cobra.Command {

	cmd := &cobra.Command{
		Use:   "config",
		Short: "Manage tron config.",
		Long:  "Manage tron config. Config contains connection information etc.",
		Args:  cobra.ExactArgs(0),
	}

	return cmd
}

// NewCmdConfigView initializes the `tron config view` command.
func NewCmdConfigView() *cobra.Command {

	cmd := &cobra.Command{
		Use:   "view",
		Short: "Show tron config.",
		Long:  "Show tron config from yaml file. Config contains connection information etc.",
		Args:  cobra.ExactArgs(0),

		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println(service.ReadConfig())
		},
	}

	return cmd
}
