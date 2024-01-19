type TextArgs = "project_id" | "region" | "bucket_id";
type BooleanArgs = "useDefaults";

// Generic for objects with keys that are either TextArgs or BooleanArgs
type FlaggedArgs<T extends TextArgs | BooleanArgs> = {
  [K in T]: K extends TextArgs ? string : boolean;
};

// Generic for objects with keys that are Flags of TextArgs or BooleanArgs
type FlagObject<T extends TextArgs | BooleanArgs> = {
  [K in T as `${K}Flag`]: FlaggedArgs<T>[K];
};

// const objectsd: FlaggedObject<TextArgs | BooleanArgs> = {//}
