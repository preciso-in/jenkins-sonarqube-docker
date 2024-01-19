import { listPendingInputs } from "./get-pending-inputs";

describe("listPendingInputs", () => {
  it("returns project_id when bucket_idFlag & regionFlag are provided", () => {
    expect(
      listPendingInputs({
        project_idFlag: "",
        bucket_idFlag: "s",
        regionFlag: "s",
      })
    ).toEqual(["project_id"]);
  });
  it("returns project_id and bucket_idFlag, when regionFlag is provided", () => {
    expect(
      listPendingInputs({
        project_idFlag: "",
        bucket_idFlag: "",
        regionFlag: "some-region",
      })
    ).toEqual(["project_id", "bucket_id"].sort());
  });
  it("returns project_id and bucket_idFlag and region when no flag is provided", () => {
    expect(
      listPendingInputs({
        project_idFlag: "",
        bucket_idFlag: "",
        regionFlag: "",
      })
    ).toEqual(["region", "project_id", "bucket_id"].sort());
  });
});
