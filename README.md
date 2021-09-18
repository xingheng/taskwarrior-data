## Taskwarrior Data

This repository is a template project for hosting [taskwarrior](https://taskwarrior.org/) data with [git-sync](https://github.com/simonthum/git-sync) script to deploy it on all of my working systems.



## File Structure

```bash
➜  taskwarrior-data git:(master) tree .
├── README.md                            # current file
├── data                                 # taskwarrior data
│   ├── backlog.data
│   ├── completed.data
│   ├── hooks -> ../hooks
│   ├── pending.data
│   └── undo.data
├── git-sync                             # core script from `git-sync`
├── git-sync-on-inotify                  # core script from `git-sync`
└── hooks                                # taskwarrior hooks
    ├── on-exit-sync
    └── on-launch-sync

3 directories, 10 files
```



## Deploy

1. Clone the current repository to local system.

   ```bash
   git clone https://github.com/xingheng/taskwarrior-data.git --branch dev
   ```

   The default `master` branch has some sample task for demo, so specify the `dev` branch to fetch a clean environment for personal usage. Recommend keeping the `dev` branch for upgrade in the future.

2. Now create a git repository code hosting service like GitHub or Bitbucket for personal data hosting, make it public or private, it’s up to you, the `git-sync` tool will use your local git configuration only.

    Add it as a new upstream in current repository, in this example we use `master` branch for data sync.

    ```bash
    git remote add mine git@github.com:your-name/taskwarrior-data.git
    git fetch mine
    git checkout --track mine/master
    ```

3. Configure it for `git-sync`.

    ```bash
    git config --bool branch.master.sync true
    git config --bool branch.master.syncNewFiles true
    ```

    It doesn’t limit you have to use `master` branch for data sync, just make sure config it right and check it out once everything ready.

4. Configure the data storage for `taskwarrior`.

    `taskwarrior` uses the `~/.task` directory as default data storage as [its docs](https://taskwarrior.org/docs/introduction.html) said, so you need rewrite the `TASKDATA` environment variable to new path in `~/.taskrc` file or move the current *taskwarrior-data* directory to the default path, migrate the existing data to *taskwarrior-data/data* directory if necessary.



## Event Trigger

When `task` command started, it will trigger the `on-launch-sync` hook script to check current git repository’s branch configuration and file status, break the `task` launch progress to run if something wrong or dirty found.

When `task` command finished, it will trigger the `on-exit-sync` hook script to update the data file status, commit the task context info with a new custom message and call the external `git-sync` script to remote master branch’s upstream, of course save all the related operation outputs to log file `git-sync.log`.



## Multiple Workspaces

I use `taskwarrior` with two workspaces, one for personal projects which track all the general task data including side projects, another one for team projects because of security data issues, so I had to create a private git repository in the our private code hosting server.

Luckily `taskwarrior` uses its environment variables `TASKRC` and `TASKDATA` to initialize the configuration and data storage path every time when launching `task`. So I use [direnv](https://direnv.net/) to separate the workspace, here is my configuration in `~/work/team-name/.envrc`:

```bash
# taskwarrior
# ------------------- BEGIN -------------------
# export TASKRC=~/.taskrc  # This is default rc.
export TASKDATA=~/work/team-name/projects/taskwarrior-data/data
# -------------------- END --------------------
```

That’s nice! When I work from the any subdirectories under the `~/work/team-name` directory, `task` takes me to the team task workspace instead of global personal one. Enjoy!



## References

[Automated Syncing With Git](https://worthe-it.co.za/blog/2016-08-13-automated-syncing-with-git.html)

[Taskwarrior - Hooks v1](https://taskwarrior.org/docs/hooks.html)

[Taskwarrior - Hooks v2](https://taskwarrior.org/docs/hooks2.html)

[Taskwarrior - Hook Author's Guide](https://taskwarrior.org/docs/hooks_guide.html)

