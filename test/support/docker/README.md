# Create user

## groupadd

Ensure in `/etc/group` the group id/name are free

```bash
groupadd -g 1001 git
```

## useradd

```
useradd -g git -d /home/git -m -r -s /bin/bash git
```

### Options

- `-d, --home HOME_DIR` The new user will be created using HOME_DIR as the value for the user's login directory. The default is to append the LOGIN name to BASE_DIR and use that as the login directory name. **The directory HOME_DIR does not have to exist but will not be created if it is missing**.

- `-m, --create-home` Create the user's home directory if it does not exist. The files and directories contained in the skeleton directory (which can be defined with the -k option) will be copied to the home directory.

  By default, if this option is not specified and CREATE_HOME is not enabled, no home directories are created.

- `-r, --system` Create a system account.
System users will be created with no aging information in /etc/shadow, and their numeric identifiers are chosen in the SYS_UID_MIN-SYS_UID_MAX range, defined in /etc/login.defs, instead of UID_MIN-UID_MAX (and their GID counterparts for the creation of groups).

  Note that useradd will not create a home directory for such an user, regardless of the default setting in /etc/login.defs (CREATE_HOME). You have to specify the -m options if you want a home directory for a system account to be created.

- `-s, --shell SHELL` The name of the user's login shell. The default is to leave this field blank, which causes the system to select the default login shell specified by the SHELL variable in /etc/default/useradd, or an empty string by default.

- `-u, --uid UID` The numerical value of the user's ID. This value must be unique, unless the -o option is used. The value must be non-negative. The default is to use the smallest ID value greater than or equal to UID_MIN and greater than every other user.

  See also the -r option and the UID_MAX description.

## docker run

```
cd test/support/docker
docker build -t 'gitserver:v1' .
docker images

# Create running container
docker run -it gitserver:v1

# Get container id
docker -qa

# Connect to running container through console session

# Connect as root user
docker exec -it CONTAINER_ID
# Connect as git user
docker exec -it --user git CONTAINER_ID
```

### docker run options

- `-i, --interactive` Keep STDIN open even if not attached
