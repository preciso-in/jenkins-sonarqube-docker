import { parse } from "./parse-arguments";
import { fetchInputs, confirm, listPendingInputs } from "./get-pending-inputs";
import { write, usage } from "./process-output";

// Return [USE_DEFAULT] if value is blank
function prepareOutput(outputObj: {
  project_idOutput: string;
  regionOutput: string;
  bucket_idOutput: string;
  defaultsOutput: boolean;
}) {
  const getPrintString = (value: string) =>
    value === "" ? "[USE_DEFAULT]" : value;

  return {
    project_idOutput: getPrintString(outputObj.project_idOutput),
    bucket_idOutput: getPrintString(outputObj.bucket_idOutput),
    regionOutput: getPrintString(outputObj.regionOutput),
    defaultsOutput: outputObj.defaultsOutput,
  };
}

function showUsage(args: string[]) {
  if (args.length === 0) {
    usage();
  }
}

async function app() {
  let project_idOutput = "";
  let bucket_idOutput = "";
  let regionOutput = "";

  const args = process.argv.slice(2);

  // Help function to show usage if no flags are provided
  showUsage(args);

  const {
    useDefaultsFlag = false,
    project_idFlag = "",
    bucket_idFlag = "",
    regionFlag = "",
  } = parse(args);

  project_idOutput += `${project_idFlag}`;
  bucket_idOutput += `${bucket_idFlag}`;
  regionOutput += `${regionFlag}`;

  const pendingInputs: boolean =
    project_idFlag === "" || bucket_idFlag === "" || regionFlag === "";

  // Write to file and exit if all inputs are provided or --use-defaults is provided
  if (useDefaultsFlag || !pendingInputs) {
    return write(
      prepareOutput({
        project_idOutput,
        bucket_idOutput,
        regionOutput,
        defaultsOutput: useDefaultsFlag,
      })
    );
  }

  const getPendingConfirmation = await confirm();

  // Write to file as user has asked for default values to be used.
  if (!getPendingConfirmation) {
    return write(
      prepareOutput({
        project_idOutput,
        bucket_idOutput,
        regionOutput,
        defaultsOutput: useDefaultsFlag,
      })
    );
  }

  const pendingInputsList = listPendingInputs({
    project_idFlag,
    bucket_idFlag,
    regionFlag,
  });

  const { project_idPending, bucket_idPending, regionPending } =
    await fetchInputs(pendingInputsList);

  project_idOutput += project_idFlag ? "" : project_idPending;
  bucket_idOutput += bucket_idFlag ? "" : bucket_idPending;
  regionOutput += regionFlag ? "" : regionPending;

  return write(
    prepareOutput({
      project_idOutput,
      bucket_idOutput,
      regionOutput,
      defaultsOutput: useDefaultsFlag,
    })
  );
}

export { app };
