FROM rockylinux:8

RUN dnf update -y && \
    dnf clean all

CMD ["/bin/bash"]
