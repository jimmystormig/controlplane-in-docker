FROM ubuntu:20.04

RUN apt-get update && apt-get install -y etcd openssl wget

WORKDIR /root
RUN wget https://dl.k8s.io/v1.23.7/bin/linux/amd64/kubeadm && \
    wget https://dl.k8s.io/v1.23.7/bin/linux/amd64/kube-apiserver && \
    wget https://dl.k8s.io/v1.23.7/bin/linux/amd64/kubectl && \
    wget https://dl.k8s.io/v1.23.7/bin/linux/amd64/kube-controller-manager && \
    wget https://dl.k8s.io/v1.23.7/bin/linux/amd64/kube-scheduler && \
    chmod +x kube* && mv kube* /usr/local/bin
RUN apt-get install -y bash-completion && \
    echo 'source /etc/bash_completion' >> ~/.bashrc && \
    echo 'source <(kubectl completion bash)' >> ~/.bashrc
ENV KUBECONFIG=/etc/kubernetes/admin.conf

COPY cert.bash ./cert.bash
COPY entrypoint.sh entrypoint.sh

VOLUME [ "/etc/kubernetes" ]
VOLUME [ "/var/lib/etcd" ]
EXPOSE 6443

CMD [ "bash", "entrypoint.sh" ]