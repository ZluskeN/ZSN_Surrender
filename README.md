# ZSN_Surrender

## Build locally

Make sure pboproject and any dependencies are installed from https://armaservices.maverick-applications.com/Products/MikerosDosTools/FileBrowserFree

Double click build.bat to generate pbo files in @zsn_surrender.
Check temp for build logs.

Any private keys in the root Keys folder will be used to sign the PBOs.
Any public keys in the root Keys folder will be copied to the mod folder.

## Build on Jenkins

Project uses Jenkinsfile to define build steps.
Add the repository or organization to Jenkins as a pipeline job and it should pick it up automatically.

It requires a node with the label "mikero" and pboproject must be available in PATH

To enable signing of PBOs, make sure a credential secret file ZLUSKEN_PRIVATE_KEY and ZLUSKEN_PUBLIC_KEY is available.
