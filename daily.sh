#!/usr/bin/env bash
# One development step a day on the license software, then a path.log line,
# a push, and a Thunderbird compose.
# A customer gits this project at their site and runs sapience in an isolated room.
# This job develops that software. It does not run the test.
set -euo pipefail

REPO="/home/lbd/Projects/ai"
BRANCH="main"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/ai-daily"
MAIL_TO="larry@refusetoown.com"
OPENCODE="/home/lbd/.local/share/mise/installs/opencode/latest/opencode"
WHAT_FILE="${REPO}/.ai-daily-what"
MAX_FILES=3
MAX_LINES=160

mkdir -p "$STATE"
chmod 700 "$STATE"
exec 9>"$STATE/lock"
if ! flock -n 9; then
  printf '%s skip: already running\n' "$(date -Is)" >&2
  exit 0
fi

export HOME="${HOME:-/home/lbd}"
export PATH="/home/lbd/.local/bin:/home/lbd/.local/share/mise/shims:/usr/local/bin:/usr/bin:/bin"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export GIT_TERMINAL_PROMPT=0
if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" && -n "${XDG_RUNTIME_DIR:-}" ]]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
fi

mode="run"
if [[ "${1:-}" == "dry" ]]; then
  mode="dry"
fi

log() {
  printf '%s %s\n' "$(date -Is)" "$*" | tee -a "$STATE/run.log" >&2
}

commit_path_log() {
  local msg="$1"
  if [[ "$(git branch --show-current)" != "$BRANCH" ]]; then
    log "path.log not committed: not on ${BRANCH}"
    return 0
  fi
  if git diff --quiet -- path.log && git diff --cached --quiet -- path.log && git ls-files --error-unmatch path.log >/dev/null 2>&1; then
    return 0
  fi
  git add -- path.log
  git commit -m "$msg" -- path.log
  git rev-parse HEAD >"$STATE/pending-push"
  if git push origin HEAD; then
    rm -f "$STATE/pending-push"
  else
    log "fail: push path.log"
  fi
}

mail_day() {
  local line body compose unit
  [[ "$mode" == "run" ]] || return 0
  line="$(grep "^${today} |" path.log | tail -n 1 || true)"
  [[ -n "$line" ]] || { log "fail: no path.log line to mail"; return 0; }
  if ! command -v thunderbird >/dev/null 2>&1; then
    log "fail: thunderbird missing"
    return 0
  fi
  body="${line//\'/’}"
  compose="to='${MAIL_TO}',subject='ai daily ${today}',body='${body}',format=text"
  unit="ai-daily-mail-$(date +%Y%m%d%H%M%S)"
  if systemd-run --user --quiet --collect --unit="$unit" \
      ${DISPLAY:+--setenv=DISPLAY="$DISPLAY"} \
      ${WAYLAND_DISPLAY:+--setenv=WAYLAND_DISPLAY="$WAYLAND_DISPLAY"} \
      ${XDG_RUNTIME_DIR:+--setenv=XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR"} \
      thunderbird -compose "$compose"
  then
    log "opened thunderbird compose for ${MAIL_TO}"
  else
    log "fail: thunderbird -compose"
  fi
}

record_day() {
  local why="$1" files
  [[ "$mode" == "run" ]] || return 0
  [[ "$day_logged" == 1 ]] && return 0
  why="$(printf '%s' "$why" | tr '|' '/' | tr -d '\r' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')"
  [[ -n "$why" ]] || why="fail: no outcome"
  why="${why:0:120}"
  if ! grep -q "^${today} |" path.log 2>/dev/null; then
    files="${target:--}"
    printf '%s | - | %s | %s | checks n/a\n' "$today" "$files" "$why" >>path.log
  fi
  day_logged=1
  commit_path_log "path.log: ${today} ${why}" || log "fail: commit path.log"
  mail_day
}

cd "$REPO"

today="$(date +%F)"
HEAD=""
agent_started=0
committed=0
day_claimed=0
day_logged=0
outcome=""
target=""
from_work=0
work_item=""

restore_script() {
  if [[ -f "$STATE/script.bak" ]]; then
    cp -a "$STATE/script.bak" "$REPO/daily.sh"
  fi
}

drop_new_untracked() {
  [[ -f "$STATE/untracked.before" ]] || return 0
  git ls-files --others --exclude-standard | LC_ALL=C sort >"$STATE/untracked.after"
  comm -13 "$STATE/untracked.before" "$STATE/untracked.after" | while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    rm -rf -- "$REPO/$f"
  done
}

reject_target() {
  [[ "${from_work:-0}" == 1 ]] && return 0
  printf '%s\t%s\n' "$today" "$1" >>"$STATE/rejected"
}

undo_agent_files() {
  local f
  if [[ -n "$HEAD" && "$(git rev-parse HEAD)" != "$HEAD" ]]; then
    if [[ "$(git branch --show-current)" != "$BRANCH" ]]; then
      log "fail: branch moved off ${BRANCH}; leaving the tree"
      return 1
    fi
    git reset --mixed "$HEAD"
  fi
  if [[ -s "$STATE/agent-files" ]]; then
    while IFS= read -r f; do
      [[ -n "$f" ]] || continue
      git checkout -f "$HEAD" -- "$f" 2>/dev/null || rm -rf -- "$REPO/$f"
    done <"$STATE/agent-files"
  fi
  drop_new_untracked
  restore_script
  rm -f "$WHAT_FILE"
}

trap 'rc=$?; if [[ "$agent_started" == 1 && "$committed" != 1 && "$rc" != 0 ]]; then undo_agent_files || true; fi; if [[ "$day_claimed" == 1 && "$day_logged" != 1 ]]; then record_day "${outcome:-fail: exit ${rc}}" || true; fi' EXIT

if [[ "$mode" == "run" && -f "${HOME}/.config/ai/daily.pause" ]]; then
  log "skip: pause file present"
  exit 0
fi

if [[ "$(git branch --show-current)" != "$BRANCH" ]]; then
  log "skip: not on ${BRANCH}"
  exit 0
fi

hour="$(date +%H)"
min="$(date +%M)"
# 08 and 09 are invalid octal. Force base 10 or 10:08 is treated as outside the window.
hour=$((10#$hour))
min=$((10#$min))
in_window=0
if [[ "$hour" -eq 10 && "$min" -le 20 ]]; then
  in_window=1
fi
if [[ "$mode" == "run" && "$in_window" == 0 ]]; then
  sid="$(loginctl list-sessions --no-legend | awk '$3=="lbd" && $0 ~ /user/ {print $1; exit}')"
  idle="no"
  if [[ -n "$sid" ]]; then
    idle="$(loginctl show-session "$sid" -p IdleHint --value 2>/dev/null || echo no)"
  fi
  if [[ "$idle" != "yes" ]]; then
    log "skip: catch-up while session is active"
    exit 0
  fi
fi

if [[ "$mode" == "run" ]]; then
  day_claimed=1
fi

if [[ -n "$(git status --porcelain --untracked-files=no)" ]]; then
  if grep -q "^${today} |" path.log 2>/dev/null; then
    commit_path_log "path.log: ${today}" || true
    day_logged=1
    day_claimed=0
    log "skip: path.log already has ${today}"
    exit 0
  fi
  log "skip: tracked tree dirty"
  outcome="fail: tracked tree dirty"
  exit 0
fi

if [[ -f "$STATE/pending-push" ]]; then
  want="$(cat "$STATE/pending-push")"
  git fetch origin "$BRANCH" || { log "fail: fetch while retrying push"; outcome="fail: fetch while retrying push"; exit 1; }
  if [[ "$(git rev-parse HEAD)" == "$want" ]] && ! git merge-base --is-ancestor "$want" "origin/${BRANCH}"; then
    git push origin HEAD
    rm -f "$STATE/pending-push"
    log "pushed pending ${want}"
  fi
fi

if [[ "$mode" == "run" ]] && grep -q "^${today} |" path.log 2>/dev/null; then
  log "skip: path.log already has ${today}"
  day_claimed=0
  exit 0
fi

if [[ "$mode" == "dry" ]]; then
  :
else
git fetch origin "$BRANCH" || { log "fail: fetch"; outcome="fail: fetch"; exit 1; }
ahead="$(git rev-list --count "origin/${BRANCH}..HEAD")"
behind="$(git rev-list --count "HEAD..origin/${BRANCH}")"
if [[ "$ahead" != "0" ]]; then
  log "skip: ${ahead} unpushed commit(s) on ${BRANCH}"
  outcome="fail: ${ahead} unpushed commit(s) on ${BRANCH}"
  exit 0
fi
if [[ "$behind" != "0" ]]; then
  git merge --ff-only "origin/${BRANCH}"
fi
fi

if [[ "$mode" == "run" ]] && grep -q "^${today} |" path.log 2>/dev/null; then
  log "skip: path.log already has ${today} after pull"
  day_claimed=0
  exit 0
fi

work_item=""
from_work=0
if [[ -f daily-work.md ]]; then
  work_item="$(grep -m1 '^- \[ \]' daily-work.md || true)"
fi
if [[ -n "$work_item" ]]; then
  target="$(printf '%s\n' "$work_item" | sed -n 's/^- \[ \] \([^:][^:]*\):.*/\1/p')"
  if [[ -z "$target" || ! -f "$target" ]]; then
    log "fail: daily work names a missing file (${target:-none})"
    outcome="fail: daily work names a missing file"
    exit 0
  fi
  from_work=1
  review_line="$(printf '%s\n' "$work_item" | sed 's/^- \[ \] //')"
  case "$target" in
    sapience|prn.c|pcn.c|ai.fst|fai.fst) change_class="instrument" ;;
    daily.sh) change_class="job" ;;
    *) change_class="document" ;;
  esac
  log "work ${target} ${review_line}"
else
targets=(prn.c pcn.c ai.fst fai.fst sapience daily.sh README.md SAPIENCE.md)
doy="$(date +%j)"
doy=$((10#$doy))
picked=""
for offset in 0 1 2 3 4 5 6 7; do
  cand="${targets[$(( (doy + offset) % 8 ))]}"
  recent=0
  if [[ -f "$STATE/rejected" ]]; then
    recent="$(awk -v today="$today" -v cand="$cand" '
      BEGIN { skip = 0 }
      {
        split($0, a, "\t")
        if (a[2] != cand) next
        cmd = "date -d " today " +%s"
        if ((cmd | getline now) < 1) next
        close(cmd)
        cmd = "date -d " a[1] " +%s"
        if ((cmd | getline then) < 1) next
        close(cmd)
        if ((now - then) / 86400 <= 7) skip = 1
      }
      END { print skip }
    ' "$STATE/rejected")"
  fi
  if [[ "$recent" == "0" ]]; then
    picked="$cand"
    break
  fi
done
if [[ -z "$picked" ]]; then
  log "skip: every target was declined this week"
  outcome="fail: every target was declined this week"
  exit 0
fi
target="$picked"
case "$target" in
  sapience|prn.c|pcn.c|ai.fst|fai.fst) change_class="instrument" ;;
  daily.sh) change_class="job" ;;
  *) change_class="document" ;;
esac
log "target ${target} class ${change_class}"
fi
if [[ "$mode" == "dry" ]]; then
  exit 0
fi

if [[ ! -x "$OPENCODE" ]]; then
  OPENCODE="$(command -v opencode || true)"
fi
if [[ -z "$OPENCODE" || ! -x "$OPENCODE" ]]; then
  log "fail: opencode not found"
  outcome="fail: opencode not found"
  exit 1
fi

if [[ "$from_work" == 1 ]]; then
  log "assigned from daily-work.md"
else
review_head="$(git rev-parse HEAD)"
review_prompt=$(cat <<EOF
Read ${REPO}/${target}. Do not edit any file. Do not commit. Do not run sapience, prn, or pcn.

This is a software-development pass. Improve the named file by one verified step.
The customer runs the test if they want to. Do not run sapience, prn, or pcn.
If you cannot verify one safe change, print exactly:
SKIP
Otherwise print exactly one line and nothing else:
CHANGE: <the one verified edit, no pipe characters, under 120 characters>
EOF
)
set +e
GROK="$(command -v grok || true)"
if [[ -n "$GROK" ]]; then
  timeout 8m "$GROK" -p --verbatim --no-alt-screen --output-format plain \
    --permission-mode plan --cwd "$REPO" "$review_prompt" \
    >"$STATE/review.txt" 2>"$STATE/review.err"
  review_rc=$?
else
  review_rc=127
fi
set -e
if [[ "$review_rc" != 0 || ! -s "$STATE/review.txt" ]]; then
  log "grok review failed (${review_rc}); opencode review"
  timeout 12m "$OPENCODE" run --dir "$REPO" --auto --title "ai daily review ${today}" \
    "$review_prompt Print the line only. Write nothing in the repo." \
    >"$STATE/review.txt" 2>"$STATE/review.err" || true
fi
if [[ "$(git rev-parse HEAD)" != "$review_head" || -n "$(git status --porcelain --untracked-files=no)" ]]; then
  log "review dirtied the tree; restoring"
  git reset --mixed "$review_head"
  git checkout -f "$review_head" -- .
fi
review_line="$(grep -E '^(SKIP|CHANGE:)' "$STATE/review.txt" | tail -1 || true)"
if [[ -z "$review_line" || "$review_line" == "SKIP" ]]; then
  log "skip: review declined ${target}"
  outcome="fail: review declined ${target}"
  reject_target "$target"
  exit 0
fi
review_line="${review_line#CHANGE: }"
log "review assigned: ${review_line}"
fi

HEAD="$(git rev-parse HEAD)"
git ls-files --others --exclude-standard | LC_ALL=C sort >"$STATE/untracked.before"
cp -a "$0" "$STATE/script.bak"
: >"$STATE/agent-files"
rm -f "$WHAT_FILE"

stay_rule="Stay inside the target. prn.c may touch recognition.h. pcn.c may touch calculation.h. Nothing else."
if [[ "$target" == "daily.sh" ]]; then
  stay_rule="The target is daily.sh. Edit that file only."
fi
prompt=$(cat <<EOF
You are the daily developer of ${REPO}. Make exactly one change, then stop.

Target: ${target}
Class: ${change_class}
Assigned change, and only this change: ${review_line}

The product is the test, the testing AI, the perceptrons, and the documentation.
A customer gits this project at their site and runs sapience in an isolated computer room to test their AI in situ.
You develop that software. You do not run the test.

Rules:
- One development step on that assignment. A wrong comment is worse than silence.
- Do not run sapience, prn, or pcn.
- Do not commit, push, amend, tag, or edit path.log, daily-work.md, .git, or any secret.
- Edit daily.sh only when it is the target.
- ${stay_rule}
- If the step cannot be one edit under ${MAX_LINES} lines, do not edit. Write exactly SKIP to ${WHAT_FILE} and stop.
- Otherwise write one line to ${WHAT_FILE}: what changed, no pipe characters, under 100 characters. Then stop.
EOF
)

agent_started=1
set +e
timeout 25m "$OPENCODE" run --dir "$REPO" --auto --title "ai daily ${today}" "$prompt" >"$STATE/agent.log" 2>&1
agent_rc=$?
set -e
log "opencode exit ${agent_rc}"

if [[ "$(git branch --show-current)" != "$BRANCH" ]]; then
  log "fail: agent left ${BRANCH}; not forcing a checkout"
  outcome="fail: agent left ${BRANCH}"
  exit 1
fi
if [[ "$(git rev-parse HEAD)" != "$HEAD" ]]; then
  git reset --mixed "$HEAD"
fi
# The running script must stay the one bash is reading. Keep a development
# edit of daily.sh aside and put it back only after this process is done.
agent_daily=0
if [[ "$target" == "daily.sh" && -f daily.sh && -f "$STATE/script.bak" ]] && ! cmp -s daily.sh "$STATE/script.bak"; then
  cp -a daily.sh "$STATE/daily.sh.new"
  agent_daily=1
fi
restore_script
rm -f "$WHAT_FILE.tmp"

if [[ -f "$WHAT_FILE" ]] && grep -qx 'SKIP' "$WHAT_FILE"; then
  log "skip: agent declined ${target}"
  outcome="fail: agent declined ${target}"
  reject_target "$target"
  undo_agent_files
  agent_started=0
  exit 0
fi

git diff --name-only HEAD | grep -vxF '.ai-daily-what' >"$STATE/agent-files" || true
git ls-files --others --exclude-standard | LC_ALL=C sort >"$STATE/untracked.after"
comm -13 "$STATE/untracked.before" "$STATE/untracked.after" | grep -vxF '.ai-daily-what' >>"$STATE/agent-files" || true
if [[ ! -s "$STATE/agent-files" ]]; then
  log "skip: agent made no change"
  outcome="fail: agent made no change"
  agent_started=0
  exit 0
fi

allowed() {
  local f="$1"
  [[ "$f" == "$target" ]] && return 0
  [[ "$target" == "prn.c" && "$f" == "recognition.h" ]] && return 0
  [[ "$target" == "pcn.c" && "$f" == "calculation.h" ]] && return 0
  [[ "$target" == "fai.fst" && "$f" == "ai.fst" ]] && return 0
  [[ "$target" == "ai.fst" && "$f" == "fai.fst" ]] && return 0
  return 1
}

bad=0
file_count=0
while IFS= read -r f; do
  [[ -n "$f" ]] || continue
  file_count=$((file_count + 1))
  case "$f" in
    *../*|/*|.git/*|path.log|daily-work.md|CONFORM.pdf|*.env|*.bak|*.bak.*) bad=1 ;;
    daily.sh) [[ "$target" == "daily.sh" ]] || bad=1 ;;
  esac
  if ! allowed "$f"; then
    bad=1
  fi
done <"$STATE/agent-files"

if [[ "$bad" != 0 || "$file_count" -gt "$MAX_FILES" ]]; then
  log "reject: change left the target or touched too many files"
  outcome="fail: change left the target or touched too many files"
  reject_target "$target"
  undo_agent_files
  agent_started=0
  exit 0
fi

lines="$(git diff --numstat -- $(git diff --name-only) | awk '{a+=$1+$2} END {print a+0}')"
if [[ "$lines" -gt "$MAX_LINES" ]]; then
  log "reject: diff is ${lines} lines"
  outcome="fail: diff is ${lines} lines"
  reject_target "$target"
  undo_agent_files
  agent_started=0
  exit 0
fi

if git diff | grep -E 'BEGIN (OPENSSH|RSA|PRIVATE) KEY|AKIA[0-9A-Z]{16}' >/dev/null; then
  log "reject: diff looks like a secret"
  outcome="fail: diff looks like a secret"
  reject_target "$target"
  undo_agent_files
  agent_started=0
  exit 1
fi

if [[ "$agent_daily" == 1 ]]; then
  if ! bash -n "$STATE/daily.sh.new"; then
    log "fail: daily.sh check failed"
    outcome="fail: daily.sh check failed"
    undo_agent_files
    agent_started=0
    exit 1
  fi
  cp -a "$STATE/daily.sh.new" daily.sh
  grep -qxF 'daily.sh' "$STATE/agent-files" || echo daily.sh >>"$STATE/agent-files"
fi
if ! bash -n sapience || ! bash -n daily.sh || ! cc -std=c11 -O2 -Wall -o "$STATE/prn" prn.c -lm || ! cc -std=c11 -O2 -Wall -o "$STATE/pcn" pcn.c -lm; then
  log "fail: checks failed"
  outcome="fail: checks failed"
  undo_agent_files
  agent_started=0
  exit 1
fi

what="one verified change"
if [[ -f "$WHAT_FILE" ]]; then
  what="$(head -1 "$WHAT_FILE" | tr '|' ' ' | tr -d '\r' | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//')"
fi
if [[ -z "$what" || "$what" == "SKIP" ]]; then
  what="one verified change in ${target}"
fi
what="${what:0:90}"
case "$what" in
  instrument:*|document:*) ;;
  *) what="${change_class}: ${what}" ;;
esac
stat="$(git diff --numstat | awk '{a+=$1;b+=$2} END {printf "(+%d/-%d)", a+0, b+0}')"
case "$what" in
  *"(+"*) ;;
  *) what="${what} ${stat}" ;;
esac

grep -v '^$' "$STATE/agent-files" | LC_ALL=C sort -u >"$STATE/agent-files.sorted"
mv "$STATE/agent-files.sorted" "$STATE/agent-files"
files="$(paste -sd, "$STATE/agent-files")"
git add --pathspec-from-file="$STATE/agent-files"
git commit -m "$what"
code_hash="$(git rev-parse --short HEAD)"

printf '%s | %s | %s | %s | checks pass\n' \
  "$today" "$code_hash" "$files" "$what" >>path.log
if [[ "$from_work" == 1 ]]; then
  awk -v d="$today" '
    BEGIN { done = 0 }
    {
      if (!done && $0 ~ /^- \[ \]/) {
        sub(/^- \[ \]/, "- [x] " d " ")
        done = 1
      }
      print
    }
  ' daily-work.md >"$STATE/daily-work.new"
  mv "$STATE/daily-work.new" daily-work.md
fi
day_logged=1
git add path.log
if [[ "$from_work" == 1 ]]; then
  git add daily-work.md
fi
git commit -m "path.log: ${today} ${what}"
committed=1
mail_day
rm -f "$WHAT_FILE"

git rev-parse HEAD >"$STATE/pending-push"
git push origin HEAD
rm -f "$STATE/pending-push"
log "pushed ${code_hash} ${what}"
