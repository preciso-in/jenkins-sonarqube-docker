describe("parse-arguments when no arguments are passed", () => {
  it("parses --use-defaults as useDefaults with value false", () => {
    jest.doMock("minimist", () => {
      return jest.fn(() => ({
        "use-defaults": true,
        "project-id": "project_idFlag",
        "bucket-id": "bucket_idFlag",
        region: "regionFlag",
      }));
    });
    const { parse } = require("./parse-arguments");

    expect(parse([])).toEqual({
      useDefaultsFlag: true,
      project_idFlag: "project_idFlag",
      bucket_idFlag: "bucket_idFlag",
      regionFlag: "regionFlag",
    });
  });

  it("parses --use-defaults as useDefaults with value false when no flags are provided", () => {
    jest.resetAllMocks();
    jest.doMock("minimist", () => {
      return jest.fn(() => ({}));
    });
    const { parse } = require("./parse-arguments");

    expect(parse([])).toEqual({
      useDefaultsFlag: false,
      project_idFlag: "",
      bucket_idFlag: "",
      regionFlag: "",
    });
  });

  it("parses --use-defaults as useDefaults with value false even when minimist returns nothing", () => {
    jest.resetAllMocks();
    jest.doMock("minimist", () => {
      return jest.fn(() => {
        return undefined;
      });
    });
    const { parse } = require("./parse-arguments");

    expect(parse([])).toEqual({
      useDefaultsFlag: false,
      project_idFlag: "",
      bucket_idFlag: "",
      regionFlag: "",
    });
  });
});
