# AGENTS.md

## 项目是什么

基于 AutoGluon 扩展的自动化机器学习 **Docker 镜像工程**（pyf-automl）。注意：这不是普通 Python 包项目——没有 requirements.txt / pytest / CI，代码不直接运行，而是构建成镜像后部署使用。

## 目录与角色

- `docker/Dockerfile` —— 唯一有效构建源（基于 `nvidia/cuda:13.0.0-runtime-ubuntu22.04`，安装 autogluon 1.6.3 + jupyterlab，`WORKDIR /opt/code/`）；build 上下文就是 `docker/` 目录
- `docker/v0.8.2_Dockerfile` —— 旧版备份（基于官方 `autogluon/autogluon:0.8.2` 镜像），改 Dockerfile 时**无需维护它**
- `docker/jupyter_lab_config.py` —— JupyterLab 配置（`allow_root=True`、`ip='*'`、`ServerApp.token=''`）；配置被 COPY 到 `/root/.jupyter/`，启动时自动加载
- `code/` —— 部署时 bind-mount 到容器内 `/opt/code/`；含测试入口 `test-igis-automl.ipynb`、数据集 `code/dataset/aws/`、AutoGluon 官方示例
- 根目录 `.sh` 脚本是仓库定义的工作流；均为 bash，脚本内用 `cd \`dirname $0\`` 自定位，需在**仓库根目录**调用

## 常用命令（Linux/WSL 部署节点，勿在 Windows 直接执行）

| 命令 | 作用 |
| --- | --- |
| `./build.sh` | 在 `docker/` 下构建镜像 `pyf-automl:1.6.3`（体积较大，耗时长） |
| `./run.sh` | 后台启动容器，需 NVIDIA GPU（`--gpus all`），映射 `code/`→`/opt/code/`，端口 8888 |
| `./test.sh` | 以 bash 交互进入容器（比 run.sh 多挂载 docker.sock，容器内可调 docker）；不启动 JupyterLab |
| `./log.sh` | `docker logs -f` 实时日志 |
| `./stop.sh` | 停止容器 |

## 验证方式（无 CI / 无单元测试）

测试 = 构建镜像 + 运行容器后，在 JupyterLab 中打开并运行 `code/test-igis-automl.ipynb`。改 `docker/` 内容需要重新 `./build.sh`；改 `code/` 内容因是 bind-mount，重启容器或直接在 `/opt/code/` 下可见。

## 易错点

- 容器名固定为 `pyf-automl`，重复 `./run.sh` 前必须先 `./stop.sh`，否则容器名冲突
- 容器内 8888 端口**无令牌可直接访问**（由 `jupyter_lab_config.py` 的 `c.ServerApp.token = ''` 控制）；改 JupyterLab 配置注意此点
- 构建依赖国内镜像源（aliyun apt、清华 pip），改 Dockerfile 时保持此约定（离线/无内网镜像会失败）
- `.gitignore` 仅忽略 `/code/models`（AutoGluon 模型输出）与 `.ipynb_checkpoints`