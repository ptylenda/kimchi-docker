FROM centos/devtoolset-7-toolchain-centos7 as builder
MAINTAINER Piotr Tylenda <tylenda.piotr@gmail.com>

ARG KIMCHI_VERSION=2.5.0
ARG WOK_VERSION=2.5.0

WORKDIR /src

USER 0

RUN yum update -y && \
    yum install -y gcc make autoconf automake gettext-devel git \
                   rpm-build libxslt python-lxml

RUN git clone --single-branch -b $WOK_VERSION https://github.com/kimchi-project/wok.git && \
    cd wok && \
    ./autogen.sh --system && \
    make && \
    make rpm

RUN git clone --single-branch -b $KIMCHI_VERSION https://github.com/kimchi-project/kimchi.git && \
    cd kimchi && \
    ./autogen.sh --system && \
    make && \
    make rpm



FROM centos/systemd
MAINTAINER Piotr Tylenda <tylenda.piotr@gmail.com>

ARG KIMCHI_VERSION=2.5.0
ARG WOK_VERSION=2.5.0

WORKDIR /tmp

COPY --from=builder /src/wok/rpm/RPMS/noarch/wok-$WOK_VERSION-0.el7.noarch.rpm wok.el7.noarch.rpm
COPY --from=builder /src/kimchi/rpm/RPMS/noarch/kimchi-$WOK_VERSION-0.el7.noarch.rpm kimchi.el7.noarch.rpm

RUN yum update -y && \
    yum install -y epel-release && \
    yum update -y && \
    yum install -y python-cherrypy python-cheetah PyPAM m2crypto \
                   python-jsonschema python-psutil python-ldap \
                   python-lxml nginx openssl python-websockify \
                   logrotate fontawesome-fonts python-websockify \
                   python-jsonschema nginx python-psutil && \
    yum install -y libvirt-python libvirt libvirt-daemon-config-network \
                   qemu-kvm python-ethtool sos python-ipaddr nfs-utils \
                   iscsi-initiator-utils pyparted python-libguestfs \
                   libguestfs-tools novnc spice-html5 \
                   python-configobj python-magic python-paramiko \
                   python-pillow novnc python-jsonschema python-psutil spice-html5 && \
    yum clean all -y && \
    rm -rf /var/cache/yum


RUN yum install -y wok.el7.noarch.rpm && \
    yum install -y kimchi.el7.noarch.rpm && \
    rm -f wok.el7.noarch.rpm kimchi.el7.noarch.rpm && \
    systemctl enable wokd.service

EXPOSE 8001 8010

CMD ["/usr/sbin/init"]
