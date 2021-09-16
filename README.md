## Taskwarrior Data

This repository is used for hosting all kinds of my task data for general cases.

At this starter point, I use [git-sync](https://github.com/simonthum/git-sync) script to deploy it on my macs.



#### File Structure

```bash
➜  taskwarrior-data git:(master) tree .
├── README.md                            # current file
├── data                                 # taskwarrior data
│   ├── backlog.data
│   ├── completed.data
|   ├── hooks -> ../hooks
│   ├── pending.data
│   └── undo.data
├── git-sync                             # core script from `git-sync`
├── git-sync-on-inotify                  # core script from `git-sync`
└── hooks                                # taskwarrior hooks
    ├── on-exit-sync
    └── on-launch-sync

3 directories, 10 files
```



#### Deploy

Clone the current repository to local system and configure it for `git-sync`:

```bash
git config --bool branch.master.sync true
git config --bool branch.master.syncNewFiles true
```



#### Event Trigger

When `task` command started, it will trigger the `on-launch-sync` hook script to check current git repository’s file status and break the `task` continue to run if something dirty found.

When `task` command finished, it will trigger the `on-exit-sync` hook script to update the data file status, commit the task context info with a new custom message and call the external `git-sync` script to remote master branch’s upstream, of course save all the related operation outputs to log file `git-sync.log`.



#### launchctl (unused, untested)

`launchd` configuration file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>logger</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/hanwei/Documents/Projects/gitRepository/taskwarrior-data/git-sync</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>/Users/hanwei/Documents/Projects/gitRepository/taskwarrior-data/data</string>
    </array>
</dict>
</plist>
```

Load config file:

```bash
launchctl load ~/Library/LaunchAgents/willhan.taskwarrior.data.sync.plist
```



#### References

[Automated Syncing With Git](https://worthe-it.co.za/blog/2016-08-13-automated-syncing-with-git.html)

[Taskwarrior - Hooks v1](https://taskwarrior.org/docs/hooks.html)

[Taskwarrior - Hooks v2](https://taskwarrior.org/docs/hooks2.html)

[Taskwarrior - Hook Author's Guide](https://taskwarrior.org/docs/hooks_guide.html)

