# Description: Asks arguments (project_id, region and bucket_id)
# from command line if not provided as arguments
# Arguments: $@
# Returns: Configuration variables as environment variables

handle_arguments() {
	npx tsx ./getInputs/index.ts $@
}
