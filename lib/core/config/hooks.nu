$env.config.hooks = {
  pre_prompt: [{ ||
    if (which direnv | is-empty) {
      return
    }

    direnv export json | from json | default {} | load-env
    if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
      $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
    }
  }] # run before the prompt is shown
  pre_execution: [{ null }] # run before the repl input is run
  env_change: {
    PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
  }
  display_output: "if (term size).columns >= 100 { table -e } else { table }" # run to display the output of a pipeline
  command_not_found: { null } # return an error message when a command is not found
}
