# Microsoft Visual Studio Code (2 November - Git Configuration)

|  CP Information |            |
|------------------|------------|
| Package | [Microsoft Visual Studio Code](https://code.visualstudio.com/) |
| Script Name | [vscode-cp-init-script.sh](vscode-cp-init-script.sh) |
| Packing Notes | See build script for details |
| Package automation | [build-vscode-cp.sh](build/build-vscode-cp.sh) |

-----

## Git Configuration

[Customizing Git - Git Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)

```bash
$ git config --global user.name "John-Doe"
$ git config --global user.email johndoe@example.com
  ```

This is written into `~/.gitconfig` and the content of the file looks like this:

```bash
[user]
	name = John-Doe
	email = gohndoe@example.com
  ```