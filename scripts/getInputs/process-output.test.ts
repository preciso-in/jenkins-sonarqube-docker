import fs, { promises } from "fs";
import { createFile, write } from "./process-output";

jest.mock("fs", () => ({
  promises: {
    mkdir: jest.fn(),
    writeFile: jest.fn(),
  },
  existsSync: jest.fn(),
}));

describe("write", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    jest.resetModules();
    jest.resetAllMocks();
  });
  const filePath = "./test/file/path";
  const dirPath = filePath.substring(0, filePath.lastIndexOf("/"));

  it("first checks if file exists", async () => {
    (fs.existsSync as jest.Mock).mockReturnValue(true);
    await createFile(filePath);

    expect(fs.existsSync).toHaveBeenCalledTimes(1);
    expect(fs.existsSync).toHaveBeenNthCalledWith(1, filePath);
  });

  it("checks if directory exists if file does not exist", async () => {
    (fs.existsSync as jest.Mock)
      .mockReturnValueOnce(false)
      .mockReturnValueOnce(true);

    await createFile(filePath);

    expect(fs.existsSync).toHaveBeenCalledTimes(2);
    expect(fs.existsSync).toHaveBeenNthCalledWith(1, filePath);
    expect(fs.existsSync).toHaveBeenNthCalledWith(2, dirPath);
  });

  it("Creates file if it does not exist", async () => {
    (fs.existsSync as jest.Mock).mockReturnValueOnce(false);
    (promises.writeFile as jest.Mock).mockReturnValueOnce(true);

    await createFile(filePath);
    expect(promises.writeFile).toHaveBeenCalledTimes(1);
    expect(promises.writeFile).toHaveBeenNthCalledWith(1, filePath, "");
  });
});
