
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

LOG_FILE="${SCRIPTPATH}/git-sync.log"

function log_start() {
    echo -e "\n---------- $(date +%FT%T) ----------" >> "${LOG_FILE}"
}

function log_message() {
    local message="$1"
    local stdout="$2"

    if [[ "$stdout" =~ "show" ]]; then
        echo -e "\n$1" >> "${LOG_FILE}"
    fi
}

function task-sync() {
    local path="${HOME}/gitRepo/taskwarrior-data"
    local logfile="${path}/git-sync.log"

    echo -e "\n---------- $(date +%FT%T) ----------" >> "${logfile}"
    echo -e "task-sync: sync taskwarrior-data to lastest...\n" &>>"${logfile}"
    (cd "${path}" && sh ./git-sync) &>>"${logfile}" & disown
}
