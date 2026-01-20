use ../shared/external *;

const SESSION_NAME = "terminal";

const TM = "zellij";
const TM_SESSION_ATTACH_CMD = [ $TM a $SESSION_NAME ];
const TM_SESSION_MAKE_CMD = [ $TM -s $SESSION_NAME ];

const TM_ENV_VAR = "ZELLIJ";

# launch the terminal multiplexer at terminal startup insha'Allah
export def main [ ] {
  # check is it configured work or not
  if not ($env.config.plugins.tm.enabled?) {
    return;
  }

  # check if the terminal multiplexer is already running
  if ($env | get -o $TM_ENV_VAR | is-not-empty) {
    return;
  }

  # nu-lint-ignore: spread_list_to_external
  external exist --stdout-message true --stdlib true [ $TM ];

  try {
    run-external $TM_SESSION_ATTACH_CMD;

  } catch {
    run-external $TM_SESSION_MAKE_CMD;
    run-external $TM_SESSION_ATTACH_CMD;

  }
}
