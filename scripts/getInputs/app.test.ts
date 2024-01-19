jest.mock("./get-pending-inputs");
jest.mock("./parse-arguments");
jest.mock("./process-output");
const { app } = require("./app");

const parseArguments = require("./parse-arguments");
import { write, usage } from "./process-output";

const getPendingInputs = require("./get-pending-inputs");
const { parseOutputs, pendingInputs } = require("./app-test-inputs");

beforeEach(() => {
  jest.resetAllMocks();
});
describe("When --use-defaults is provided", () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it("skips confirmation of pending inputs whether flags are provided or not", async () => {
    getPendingInputs.confirm.mockImplementation(() => {});

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.noFlagsWithDefaults;
    });
    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.allFlagsWithDefaults;
    });
    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.oneFlagWithDefaults;
    });
    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.twoFlagsWithDefaults;
    });
    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();
  });

  it("skips fetching of pending inputs", async () => {
    getPendingInputs.fetchInputs.mockImplementation(() => {});

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.noFlagsWithDefaults;
    });
    await app();
    expect(getPendingInputs.fetchInputs).not.toHaveBeenCalled();

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.allFlagsWithDefaults;
    });
    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.oneFlagWithDefaults;
    });
    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.twoFlagsWithDefaults;
    });
    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();
  });
});

describe("When --use-defaults is not provided", () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it("skips confirmation of pending inputs when all flags are provided", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.allFlagsWithoutDefaults;
    });
    getPendingInputs.confirm.mockImplementation(() => {});

    await app();
    expect(getPendingInputs.confirm).not.toHaveBeenCalled();
  });

  it("gets confirmation of pending inputs on missing flags", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.twoFlagsWithoutDefaults;
    });
    getPendingInputs.confirm.mockImplementation(() => {});

    await app();
    expect(getPendingInputs.confirm).toHaveBeenCalled();
    expect(getPendingInputs.confirm.mock.calls).toHaveLength(1);

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.oneFlagWithoutDefaults;
    });

    await app();
    expect(getPendingInputs.confirm).toHaveBeenCalled();
    expect(getPendingInputs.confirm.mock.calls).toHaveLength(2);

    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.noFlagsWithoutDefaults;
    });

    await app();
    expect(getPendingInputs.confirm).toHaveBeenCalled();
    expect(getPendingInputs.confirm.mock.calls).toHaveLength(3);
  });
});

describe("When user provides confirmation for pending inputs", () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it("fetches pending inputs when user says yes", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.twoFlagsWithoutDefaults;
    });
    getPendingInputs.confirm.mockImplementation(() => true);
    getPendingInputs.fetchInputs.mockImplementation(() => ({}));

    await app();
    expect(getPendingInputs.fetchInputs).toHaveBeenCalled();
  });

  it("fetches no pending inputs when user says no", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.twoFlagsWithoutDefaults;
    });
    getPendingInputs.confirm.mockImplementation(() => false);
    getPendingInputs.fetchInputs.mockImplementation(() => ({}));

    await app();
    expect(getPendingInputs.fetchInputs).not.toHaveBeenCalled();
  });
});

describe("Fetches only those inputs that are not provided in command line as flags", () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it("Fetches no pending input when all flags are provided", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.allFlagsWithoutDefaults;
    });

    getPendingInputs.confirm.mockImplementation(() => true);
    getPendingInputs.fetchInputs.mockImplementation(() => ({}));

    await app();
    expect(getPendingInputs.fetchInputs).not.toHaveBeenCalled();
  });

  it("gets list of pending inputs correctly when two flags are provided", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.twoFlagsWithoutDefaults;
    });

    getPendingInputs.confirm.mockImplementation(() => true);
    getPendingInputs.fetchInputs.mockImplementation(() => ({}));

    await app();
    expect(getPendingInputs.listPendingInputs).toHaveBeenCalled();
    expect(getPendingInputs.listPendingInputs.mock.calls).toHaveLength(1);
    expect(getPendingInputs.listPendingInputs).toHaveBeenCalledWith({
      bucket_idFlag: "",
      project_idFlag: "project_idFlag",
      regionFlag: "regionFlag",
    });
  });

  it("Gets list of pending inputs correctly when one flag is provided", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.oneFlagWithoutDefaults;
    });

    getPendingInputs.confirm.mockImplementation(() => true);
    getPendingInputs.fetchInputs.mockImplementation(() => ({}));

    await app();
    expect(getPendingInputs.listPendingInputs).toHaveBeenCalled();
    expect(getPendingInputs.listPendingInputs.mock.calls).toHaveLength(1);
    expect(getPendingInputs.listPendingInputs).toHaveBeenCalledWith({
      bucket_idFlag: "",
      project_idFlag: "",
      regionFlag: "regionFlag",
    });
  });

  it("Gets list of pending inputs correctly when no flag is provided", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.noFlagsWithoutDefaults;
    });

    getPendingInputs.confirm.mockImplementation(() => true);
    getPendingInputs.fetchInputs.mockImplementation(() => ({
      project_idPending: "project_idPending",
      bucket_idPending: "bucket_idPending",
      regionPending: "regionPending",
    }));

    await app();
    expect(getPendingInputs.listPendingInputs).toHaveBeenCalled();
    expect(getPendingInputs.listPendingInputs.mock.calls).toHaveLength(1);
    expect(getPendingInputs.listPendingInputs).toHaveBeenCalledWith({
      bucket_idFlag: "",
      project_idFlag: "",
      regionFlag: "",
    });
  });
});

describe("Output contains flags passed in command line", () => {
  beforeEach(() => {
    jest.resetAllMocks();
  });

  it("Contains flags and defaults when --use-defaults is provided", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.oneFlagWithDefaults;
    });

    await app();
    expect(write).toHaveBeenCalled();

    expect(write).toHaveBeenCalledWith({
      project_idOutput: "[USE_DEFAULT]",
      bucket_idOutput: "[USE_DEFAULT]",
      regionOutput: "regionFlag",
      defaultsOutput: true,
    });
  });

  it("Contains all flags passed in command line", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.twoFlagsWithDefaults;
    });

    await app();
    expect(write).toHaveBeenCalled();

    expect(write).toHaveBeenCalledWith({
      project_idOutput: "project_idFlag",
      bucket_idOutput: "[USE_DEFAULT]",
      regionOutput: "regionFlag",
      defaultsOutput: true,
    });
  });

  it("Contains all flags passed in command line and defaults for missing values", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.oneFlagWithDefaults;
    });

    getPendingInputs.confirm.mockImplementation(() => false);
    getPendingInputs.fetchInputs.mockImplementation(() => ({
      project_idPending: "project_idPending",
      bucket_idPending: "bucket_idPending",
      regionPending: "regionPending",
    }));

    await app();
    expect(write).toHaveBeenCalled();

    expect(write).toHaveBeenCalledWith({
      project_idOutput: "[USE_DEFAULT]",
      bucket_idOutput: "[USE_DEFAULT]",
      regionOutput: "regionFlag",
      defaultsOutput: true,
    });
  });

  it("Contains defaults values in missing inputs when consumer confirms use of default values ", async () => {
    parseArguments.parse.mockImplementation(() => {
      return parseOutputs.oneFlagWithoutDefaults;
    });

    getPendingInputs.confirm.mockImplementation(() => true);
    getPendingInputs.fetchInputs.mockImplementation(() => ({
      project_idPending: "project_idPending",
      bucket_idPending: "bucket_idPending",
      regionPending: "regionPending",
    }));

    await app();
    expect(write).toHaveBeenCalled();

    expect(write).toHaveBeenCalledWith({
      project_idOutput: "project_idPending",
      bucket_idOutput: "bucket_idPending",
      regionOutput: "regionFlag",
      defaultsOutput: false,
    });
  });
});
