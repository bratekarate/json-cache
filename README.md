# json-cache

Save JSON responses to a temporary file in a JSON array. An index is assigned to
each element to make entries easily distinguished when inspecting. Intended to
save results from multiple queries and then later iterate over them using `jq`.

## Dependencies:
  - `jq`
  - `less`

## Installation

```sh
git clone https://github.com/bratekarate/json-cache.git
```
- Create symbolic links from each script file to any directory that is on the PATH. The link target must not contain any extensions such as `.sh`.

### Linux
- Should be the same for WSL (untested).
- Example using the provided install script:
```sh
./install.sh "$HOME"/.local/bin
```

### Windows (MSYS or CYGWIN)
- Symbolic links can only be created with administrator privileges.
- `curl` is expected to be already installed. The latest `jq` binary must be downloaded from github.
- `jq` does not yet support binary mode, meaning it will always output in `CLRF` line endings. `-b` flag is already supported on master, but unreleased. Nevertheless, this project's programs will not be adapted just to work on windows. Instead, a wrapper script around`jq`should be put into place.

Example using the provided install script (`jq` download and creating wrapper script included). Must be run in an elevated bash terminal:
```sh
# Example for MSYS (used by git bash)

# cd <PROJECT_DIR>
./install.sh msys "$HOME"/bin
```
- The `"$HOME"/bin` directory is just an example and may not exist and not be part of the `$PATH` environment variable. Either a `bin` directory must be created at a chosen location and added to `$PATH`, or alternatively, `/usr/bin` may be used as a second parameter for the install script.

## Usage

```
# add entries cache
curl <some request> | jq_append

# inspect entries
jq_show

# inspect with pager
jq_show | jq_less

# remove with index from cache
jq_remove 4

# remove all from cache 
jq_remove a

# iterate ids of entries

jq_show | jq '.id' |
  while IFS= read -r ID; do
    # do stuff with $ID
  done
```

See [gitlab-cli](git clone https://github.com/bratekarate/gitlab-cli#usage.git)
