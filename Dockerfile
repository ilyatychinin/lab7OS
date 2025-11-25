FROM rockylinux:9

RUN dnf update -y && \
    dnf clean all

CMD ["/bin/bash"]
