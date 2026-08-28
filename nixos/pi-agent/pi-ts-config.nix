# Generates a `pi-tsconfig` npm package into the repo so tsgo/TypeScript LSP
# can resolve pi's types from the Nix store (paths change on update).
#
# Output: home.file entries for `node_modules/pi-tsconfig/{package.json,tsconfig.json}`.
{
  lib,
  piPackage, # pi-coding-agent package (or null)
  piAgentModule, # path to nixos/pi-agent in the repo
}:
let
  piTsconfig = builtins.toJSON {
    compilerOptions = {
      target = "ES2023";
      module = "ESNext";
      moduleResolution = "Bundler";
      noEmit = true;
      strict = true;
      skipLibCheck = true;
      paths = {
        "@earendil-works/pi-coding-agent" = [ "${piPackage}/lib/node_modules/pi-monorepo/dist/index.d.ts" ];
        "@earendil-works/pi-ai" = [
          "${piPackage}/lib/node_modules/pi-monorepo/node_modules/@earendil-works/pi-ai/dist/index.d.ts"
        ];
        "@earendil-works/pi-tui" = [
          "${piPackage}/lib/node_modules/pi-monorepo/node_modules/@earendil-works/pi-tui/dist/index.d.ts"
        ];
        typebox = [ "${piPackage}/lib/node_modules/pi-monorepo/node_modules/typebox/build/index.d.mts" ];
      };
    };
  };

  piTsconfigPkg = builtins.toJSON {
    name = "pi-tsconfig";
    version = "1.0.0";
    private = true;
  };
in
{
  "${piAgentModule}/node_modules/pi-tsconfig/package.json" = lib.mkIf (piPackage != null) {
    text = piTsconfigPkg;
  };

  "${piAgentModule}/node_modules/pi-tsconfig/tsconfig.json" = lib.mkIf (piPackage != null) {
    text = piTsconfig;
  };
}
