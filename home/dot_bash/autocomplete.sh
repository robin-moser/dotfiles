#!/usr/bin/env bash

# select from the history of commands in the current directory,
# using fzf and aw-watcher-shell
__aw_history_in_dir() {
    python3 - "$PWD" << PYEOF
import sys
from aw_client import ActivityWatchClient
from datetime import datetime, timedelta, timezone

client = ActivityWatchClient()
end = datetime.now(timezone.utc)
start = end - timedelta(days=$AW_HISTORY_DAYS)
cwd = sys.argv[1]

query = f'''
events = query_bucket("${AW_HISTORY_BUCKET}");
events = filter_keyvals(events, "cwd", ["{cwd}"]);
events = sort_by_timestamp(events);
RETURN = events;
'''

result = client.query(query, timeperiods=[(start, end)])
seen = set()
for e in reversed(result[0]):
    cmd = e['data']['cmdStr']
    if cmd not in seen:
        seen.add(cmd)
        ts = datetime.fromisoformat(e['timestamp'].replace('Z', '+00:00'))
        print(f"{ts.strftime('%y-%m-%d %H:%M')}  {cmd}")
PYEOF
}

__fzf_history_dir__() {
    local selected
    selected=$(__aw_history_in_dir | fzf --query "$READLINE_LINE" --accept-nth=3..)
    READLINE_LINE="$selected"
}

bind -x '"\C-t": __fzf_history_dir__'
