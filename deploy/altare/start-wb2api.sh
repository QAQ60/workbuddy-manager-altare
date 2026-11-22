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

cd /app
# stdout 写对话日志（供账号回填）；stderr 不重定向，直接进容器 stderr 便于 Altare 日志查看。
# 工作目录必须是 /app：上游镜像 entrypoint 就在 /app，相对路径按它解析。
/app/wb2api -config "$CFG" >> "${LOGDIR}/server.out.log" &
echo $! > "$PIDFILE"
exit 0
