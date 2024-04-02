# XZ to GZ

Convert all `tar.xz` files in a specified directory to `tar.gz` through a docker container acting as a virtual machine.

[DockerHub](https://hub.docker.com/repository/docker/aspiesoft/xz2gz/general)

## Usage

```shell
docker run -v <My Input Directory>:/input aspiesoft/xz2gz:latest

# example
docker run -v ./dir:/input aspiesoft/xz2gz:latest
```

## How To Handle Output (Optional)

```shell
docker run -v <My Input Directory>:/input -e XZMODE="<Choose Method>" aspiesoft/xz2gz:latest

# example
docker run -v ./dir:/input -e XZMODE="remove" aspiesoft/xz2gz:latest
```

### XZMODE Methods

- **remove**: (default) removes \<file\>.tar.xz after successfully creating \<file\>.tar.gz
- **keep**: keeps \<file\>.tar.xz without touching it
- **rename**: removes \<file\>.tar.xz, then renames \<file\>.tar.gz to \<file\>.tar.xz
- **link**: removes \<file\>.tar.xz, then creates a symlink to \<file\>.tar.gz named \<file\>.tar.xz
- **rename-link**: removes \<file\>.tar.xz, then renames \<file\>.tar.gz to \<file\>.tar.xz, then creates a symlink to \<file\>.tar.xz named \<file\>.tar.gz

#### Why rename a .tar.gz file to .tar.xz?

For the `tar` command in linux, it is considered a best practice to use `tar -xf` and not `tar -xJf` or `tar -xzf`.
This means it is more common not to specify a compression algorithm when decompressing archives, and to instead
let the `tar` command handle it. The `tar` command in linux does not care what the file extension is, and actually
reads the headers of the file to determine whether it is `.xz` or `.gz` that should be used for decompression.

If you need to convert a `.tar.xz` file to `.tar.gz`, and cannot change a program to look for .gz instead of .xz,
if that program happens to follow the linux best practice, then we can force the `.tar.gz` file to be compatible,
by renaming it to `.tar.xz`. It will still use the `.gz` algorithm, but the program will still find its expected
`.xz` file.

Note: If a specific program does not follow the linux best practice, and chose to specify a decompression algorithm
like `tar -xJf`, then the program may run into errors.
