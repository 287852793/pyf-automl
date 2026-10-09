FROM nvidia/cuda:13.0.0-runtime-ubuntu22.04

# 设置环境变量，确保后续的命令不会等待用户输入
ENV DEBIAN_FRONTEND=noninteractive

### change the system source for installing libs
ARG USE_SRC_INSIDE=true
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ;
RUN sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list ;
RUN echo "Use aliyun source for installing libs" ;

# 更新包索引
RUN apt-get update
RUN apt-get install -y --no-install-suggests --no-install-recommends \
  vim wget curl dmidecode tzdata poppler-utils python3 python3-pip 
RUN apt-get install -y libgomp1

# make some useful symlinks that are expected to exist
RUN ln -sf /usr/bin/pydoc3 /usr/local/bin/pydoc
RUN ln -sf /usr/bin/python3 /usr/local/bin/python

# setup autogluon
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install -U pip
RUN pip install -U setuptools wheel
RUN pip install --no-cache-dir --retries 10 --timeout 120 "autogluon==1.6.3"

# setup jupyter
RUN pip3 install jupyterlab
RUN pip3 install jupyter-core
RUN pip3 install --upgrade ipykernel
COPY jupyter_lab_config.py /root/.jupyter/jupyter_lab_config.py

# ---- 其他依赖（2026-09-30）----
RUN apt-get update && apt-get install -y --no-install-recommends \
        libgomp1 build-essential git && \
    rm -rf /var/lib/apt/lists/*

# 小样本基础模型 + 集成
RUN pip install --no-cache-dir tabpfn
# 深度时序对照（含 PatchTST/iTransformer/N-HiTS/TFT）
RUN pip install --no-cache-dir neuralforecast
# 备选
RUN pip install --no-cache-dir pytorch-forecasting
# 校准 + Conformal
RUN pip install --no-cache-dir scikit-learn mapie

# alias
RUN echo "alias ll='ls $LS_OPTIONS -l'" >> /root/.bashrc

# timezone
RUN echo 'export LANG="C.UTF-8"'>>/root/.bashrc; \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone

# RUN pip install flask flask-sqlalchemy flask_wtf wtforms[email] flask-sijax
# 中文字体
RUN apt-get update && apt-get install -y fonts-wqy-microhei && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/code/
ENTRYPOINT ["jupyter-lab", "--port=8888", "--ip=0.0.0.0", "--no-browser", "--allow-root"]