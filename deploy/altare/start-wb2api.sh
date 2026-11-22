#!/bin/sh
# 启动/重启上游 wb2api（幂等）。native 模式下 manager 保存配置后会调用本脚本。
# PID 文件保证重复调用不会起第二个进程抢 7863 端口。
set -u
CFG="${WB_UPSTREAM_CONFIG:-/opt/workbuddy2api/config.json}"
WORKDIR="$(dirname "$CFG")"
LOGDIR="${WORKDIR}/data"
PIDFILE="/tmp/wb2api.pid"

mkdir -p "$LOGDIR"
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE" 2>/dev/null)" 2>/dev/null; then
    exit 0
fi

cd "$WORKDIR"
# stdout → server.out.log（对话日志，供账号回填），stderr → server.err.log（业务日志）
nohup /app/wb2api -config "$CFG" >> "${LOGDIR}/server.out.log" 2>> "${LOGDIR}/server.err.log" &
echo $! > "$PIDFILE"
exit 0
