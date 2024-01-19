import inquirer from "inquirer";

type PendingInputs = {
  regionPending: string;
  bucket_idPending: string;
  project_idPending: string;
};

export function listPendingInputs({
  project_idFlag,
  bucket_idFlag,
  regionFlag,
}: any) {
  const pendingInputs = [];
  if (project_idFlag === "") {
    pendingInputs.push("project_id");
  }
  if (bucket_idFlag === "") {
    pendingInputs.push("bucket_id");
  }
  if (regionFlag === "") {
    pendingInputs.push("region");
  }
  return pendingInputs.sort();
}

export async function confirm(): Promise<boolean> {
  const confirm = await inquirer.prompt([
    {
      type: "confirm",
      name: "getPendingInputs",
      message: "Do you want to input pending inputs? Type N to use defaults?",
      default: true,
    },
  ]);
  return confirm.getPendingInputs;
}

export async function fetchInputs(
  fetchInputs: string[]
): Promise<PendingInputs> {
  const inquirerPrompt = ({
    name,
    messageItem,
  }: {
    name: string;
    messageItem: string;
  }) => {
    return {
      name,
      message: `Enter the ${messageItem}`,
      default: "",
      type: "input",
    };
  };

  const getInputs = [];
  if (fetchInputs.includes("project_id")) {
    getInputs.push(
      inquirerPrompt({ name: "project_idPending", messageItem: "project ID" })
    );
  }
  if (fetchInputs.includes("bucket_id")) {
    getInputs.push(
      inquirerPrompt({ name: "bucket_idPending", messageItem: "bucket ID" })
    );
  }
  if (fetchInputs.includes("region")) {
    getInputs.push(
      inquirerPrompt({ name: "regionPending", messageItem: "region" })
    );
  }

  const pendingInputs = await inquirer.prompt(getInputs);

  return {
    project_idPending: pendingInputs?.project_idPending ?? "",
    bucket_idPending: pendingInputs?.bucket_idPending ?? "",
    regionPending: pendingInputs?.regionPending ?? "",
  };
}
