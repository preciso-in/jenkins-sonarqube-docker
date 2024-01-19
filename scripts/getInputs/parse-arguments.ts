import minimist from "minimist";

export function parse(args: string[]): FlagObject<TextArgs | BooleanArgs> {
  const processedArgs = minimist(args);

  const useDefaultsFlag = processedArgs?.["use-defaults"] ?? false;
  const project_idFlag = processedArgs?.["project-id"] ?? "";
  const bucket_idFlag = processedArgs?.["bucket-id"] ?? "";
  const regionFlag = processedArgs?.["region"] ?? "";

  const rectifyArgFlag = (flag: string | boolean): string => {
    if (typeof flag === "boolean") {
      return "";
    }
    return flag;
  };

  return {
    useDefaultsFlag,
    project_idFlag: rectifyArgFlag(project_idFlag),
    bucket_idFlag: rectifyArgFlag(bucket_idFlag),
    regionFlag: rectifyArgFlag(regionFlag),
  };
}
