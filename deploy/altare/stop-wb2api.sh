#!/bin/sh
# 停止上游 wb2api。manager 保存配置后先调本脚本，再调 start-wb2api.sh。
set -u
PIDFILE="/tmp/wb2api.pid"
if [ -f "$PIDFILE" ]; then
    PID="$(cat "$PIDFILE" 2>/dev/null || true)"
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        kill "$PID" 2>/dev/null || true
        # 最多等 5 秒让它优雅退出
        i=0
        while kill -0 "$PID" 2>/dev/null && [ "$i" -lt 50 ]; do
            sleep 0.1
            i=$((i + 1))
        done
        kill -9 "$PID" 2>/dev/null || true
    fi
    rm -f "$PIDFILE"
fi
exit 0
