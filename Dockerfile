FROM ubuntu:20.04

COPY sources.list /etc/apt/sources.list
ADD libs/jdk-8u301-linux-x64.tar.gz /opt
ADD libs/Apache_OpenOffice_4.1.5_Linux_x86-64_install-deb_zh-CN.tar.gz /root
ADD libs/freetype-2.9.tar.gz /root

COPY libs/chinese /usr/share/fonts

RUN apt update && apt upgrade -y && \
    apt install -y vim nano net-tools libxext6 make gcc libxrender1 libxt6 lsof && \
    cd /root/zh-CN/DEBS && \
    dpkg -i *.deb && \
    cd desktop-integration && dpkg -i *.deb && \
    cd /root/freetype-2.9 && \
    ./configure && \
    make && make install

VOLUME [ "/usr/local/tomcat/uploads" ]

ENV JAVA_HOME=/opt/jdk1.8.0_301
ENV CLASSPATH=.:${JAVA_HOME}/lib:${JAVA_HOME}/jre/lib
ENV PATH=${PATH}:${JAVA_HOME}/bin:${JAVA_HOME}/jre/bin
ENV LIB_LIBNARY_PATH=${LIB_LIBNARY_PATH}:/usr/local/lib

RUN ldconfig

EXPOSE 8100
WORKDIR /opt/openoffice4/program
# soffice -headless -accept="socket,host=0.0.0.0,port=8100;urp;" -nofirststartwizard &
CMD [ "./soffice", "-headless -accept='socket,host=0.0.0.0,port=8100;urp;' -nofirststartwizard &" ]