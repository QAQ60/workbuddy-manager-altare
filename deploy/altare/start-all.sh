#!/bin/sh
# 单容器入口：后台起上游 wb2api，前台跑 manager(uvicorn)。
# 由官方 entrypoint 以业务用户（su-exec）调用，因此本脚本无需关心降权。
set -eu

# 1) 先起上游（后台）
/app/deploy/start-wb2api.sh

# 2) 前景跑 manager；它是 PID 1（entrypoint exec 过来的），退出即容器退出。
exec python -m uvicorn server.main:app --host 0.0.0.0 --port "${WB_MANAGER_PORT:-7864}" --timeout-graceful-shutdown 20
