import fs from "fs";

type Output = {
  project_idOutput: string;
  bucket_idOutput: string;
  regionOutput: string;
  defaultsOutput: boolean;
};

export async function createFile(filePath: string) {
  // Create file if it does not exist using fs module
  if (!fs.existsSync(filePath)) {
    try {
      // create directory if it does not exist
      const dir = filePath.substring(0, filePath.lastIndexOf("/"));
      if (!fs.existsSync(dir)) {
        await fs.promises.mkdir(dir, { recursive: true });
      }

      await fs.promises.writeFile(filePath, "");
    } catch (err) {
      console.log("error in creating output file");
    }
  }
}

export async function write({
  project_idOutput,
  bucket_idOutput,
  regionOutput,
  defaultsOutput,
}: Output) {
  const bucket_idLine = `export BUCKET_ID_ARGS=${bucket_idOutput}`;
  const project_idLine = `export PROJECT_ID_ARGS=${project_idOutput}`;
  const regionLine = `export REGION_ARGS=${regionOutput}`;
  const defaultsLine = `export USE_DEFAULTS=${defaultsOutput}`;

  const output = `${bucket_idLine}
${project_idLine}
${regionLine}
${defaultsLine}`;

  const filePath = "./working/input-variables.sh";
  try {
    await createFile(filePath);
    await fs.promises.writeFile(filePath, output);
  } catch (err) {
    console.log("printing error");
    console.log(err);
    process.exit(1);
  }
}

export function usage() {
  console.log("\nUsage: $ gcloud-cli [OPTIONS]");
  console.log("Options:");
  console.log(" --help           Display this help message");
  console.log(" --use-defaults   Use default values for all options");
  console.log(" --bucket-id      Specify storage bucket ID\n\n");
  console.log(" --project-id     Specify project id to use");
  console.log(" --region				 Specify region to use");
}
