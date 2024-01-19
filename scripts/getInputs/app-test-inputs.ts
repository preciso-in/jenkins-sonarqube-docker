export const parseOutputs: {
  [key: string]: FlagObject<TextArgs | BooleanArgs>;
} = {
  allFlagsWithDefaults: {
    useDefaultsFlag: true,
    project_idFlag: "project_idFlag",
    bucket_idFlag: "bucket_idFlag",
    regionFlag: "regionFlag",
  },
  allFlagsWithoutDefaults: {
    useDefaultsFlag: false,
    project_idFlag: "project_idFlag",
    bucket_idFlag: "bucket_idFlag",
    regionFlag: "regionFlag",
  },

  twoFlagsWithDefaults: {
    useDefaultsFlag: true,
    project_idFlag: "project_idFlag",
    bucket_idFlag: "",
    regionFlag: "regionFlag",
  },
  twoFlagsWithoutDefaults: {
    useDefaultsFlag: false,
    project_idFlag: "project_idFlag",
    bucket_idFlag: "",
    regionFlag: "regionFlag",
  },

  oneFlagWithDefaults: {
    useDefaultsFlag: true,
    project_idFlag: "",
    bucket_idFlag: "",
    regionFlag: "regionFlag",
  },
  oneFlagWithoutDefaults: {
    useDefaultsFlag: false,
    project_idFlag: "",
    bucket_idFlag: "",
    regionFlag: "regionFlag",
  },

  noFlagsWithDefaults: {
    useDefaultsFlag: true,
    project_idFlag: "",
    bucket_idFlag: "",
    regionFlag: "",
  },
  noFlagsWithoutDefaults: {
    useDefaultsFlag: false,
    project_idFlag: "",
    bucket_idFlag: "",
    regionFlag: "",
  },
};

export const pendingInputs = {
  twoFlagsWithoutDefaults: ["bucket_id"],
  oneFlagWithoutDefaults: ["project_id", "bucket_id"],
  noFlagsWithoutDefaults: ["project_id", "bucket_id", "region"],
};
