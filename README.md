# ZSN_Surrender

## Build locally

Double click build.bat to generate pbo files in `addons` folder.

The main repository folder can be used as mod when Arma 3 is launched and it will use the built PBOs in the `addons` folder.

## Release locally

Double click `release.bat` to generate a release version in `releases`.

`zsn` key in the root `keys` folder will be used to sign the PBOs.
`zsn` key in the root `keys` folder will be copied to the mod folder.

## Build on GitHub Actions

Mod is automatically built on push and pull request.

A generated `zsn` key will be used to sign the PBOs.
