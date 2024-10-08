FROM centos:latest
RUN useradd -ms /bin/bash -p tpstps iris
RUN dnf -y install python3 \
&& yum -y install libaio.x86_64  libaio-devel.x86_64 unzip  mlocate gcc gcc-c++ vim openssl-libs.x86_64 openssl-devel.x86_64 make gdb.x86_64  tcl.x86_64 wget

WORKDIR /home
#Downloading doxygen


RUN yum clean all

WORKDIR /home

RUN wget --content-disposition http://mirror.centos.org/centos/8/PowerTools/aarch64/os/Packages/doxygen-1.8.14-12.el8.aarch64.rpm https://nodejs.org/dist/latest-v8.x/node-v8.17.0.tar.gz https://github.com/Kitware/CMake/releases/download/v3.20.0-rc3/cmake-3.20.0-rc3.tar.gz  https://github.com/redis/hiredis/archive/v1.0.0.zip https://sourceforge.net/projects/wsdlpull/files/latest/download https://download.oracle.com/otn_software/linux/instantclient/191000/oracle-instantclient19.10-basic-19.10.0.0.0-1.x86_64.rpm https://download.oracle.com/otn_software/linux/instantclient/191000/oracle-instantclient19.10-devel-19.10.0.0.0-1.x86_64.rpm https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.gz https://github.com/zeromq/libzmq/archive/v4.2.3.zip https://files.pythonhosted.org/packages/d3/7f/c780b7471ba0ff4548967a9f7a8b0bfce222c3a496c3dfad0164172222b0/supervisor-4.2.2.tar.gz https://github.com/msgpack/msgpack-c/archive/master.zip



# Installing cmake 
RUN tar -xvf cmake-3.20.0-rc3.tar.gz \
&& cd cmake-3.20.0-rc3 \
&& ./bootstrap \
&& make \
&& make install

# Installing hiredis
WORKDIR /home
RUN unzip hiredis-1.0.0.zip \ 
&& cd hiredis-1.0.0 \
&&  make \
&& make install 


# INstalling boost
WORKDIR /home
RUN tar -xvf  boost_1_75_0.tar.gz
WORKDIR boost_1_75_0 
RUN ./bootstrap.sh \
&& ./b2  define=_GLIBCXX_USE_CXX11_ABI=0 install -j2; exit 0
WORKDIR /home

# INstalling oracle
RUN dnf -y install libnsl \
&& rpm -ivh oracle-instantclient19.10-basic-19.10.0.0.0-1.x86_64.rpm \
&& rpm -ivh oracle-instantclient19.10-devel-19.10.0.0.0-1.x86_64.rpm  

WORKDIR /home

#Installing supervisord
RUN tar -xvf supervisor-4.2.2.tar.gz \
&& cd supervisor-4.2.2 \
&& python3 setup.py install
RUN wget --content-disposition https://github.com/zeromq/czmq/archive/master.zip 

WORKDIR /home
RUN   wget  --content-disposition https://github.com/doxygen/doxygen/archive/master.zip 	\
&& dnf -y install flex \
&& dnf -y install bison \
&& unzip  doxygen-master.zip \
&& cd doxygen-master  \
&& cmake -G "Unix Makefiles" . \
&&  make  \
&& make install \
&& cd ../ \
&& tar -xvf wsdlpull-1.24.tar.gz \
&& cd wsdlpull-1.24 \
&& ./configure \
&& make CXXFLAGS='-D_GLIBCXX_USE_CXX11_ABI=0' -j2 \
&& make install \
&& cp /home/wsdlpull-1.24/src/wsdlparser/*.h  /usr/local/include/wsdlpull/wsdlparser/ \
&& mkdir /usr/local/include/wsdlpull/xmlpull \
&& cp /home/wsdlpull-1.24/src/xmlpull/*.h /usr/local/include/wsdlpull/xmlpull
WORKDIR /home
RUN wget --content-disposition https://github.com/zeromq/libzmq/archive/v4.3.4.zip
RUN unzip libzmq-4.3.4.zip \
&& cd libzmq-4.3.4 \
&& mkdir cmake-make \
&& cd cmake-make \
&& cmake  -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" .. \
&& make -j3 \
&& make install
WORKDIR /home
RUN wget --content-disposition  https://github.com/zeromq/cppzmq/archive/v4.7.1.zip
RUN unzip  cppzmq-4.7.1.zip \
&& cd cppzmq-4.7.1 \
&& mkdir build \
&& cd build \
&& cmake  -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"  -DCPPZMQ_BUILD_TESTS=OFF .. \
&& make -j3 install 
WORKDIR /home
RUN wget --content-disposition https://github.com/msgpack/msgpack-c/archive/cpp_master.zip
RUN unzip msgpack-c-cpp_master.zip \
&& cd msgpack-c-cpp_master \
&& cmake  -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" . \
&& make \
&& make install 
WORKDIR /home
RUN dnf -y install  python2 
RUN tar -xvf node-v8.17.0.tar.gz
WORKDIR node-v8.17.0
RUN ./configure \
&& make -j3 \
&& make install
RUN yum install -y postgresql-devel
WORKDIR /home
RUN wget --content-disposition https://github.com/jtv/libpqxx/archive/7.4.1.zip 
RUN unzip libpqxx-7.4.1.zip \
&& cd libpqxx-7.4.1 \
&& cmake -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" .  .. \
&& make \
&& make install \
&& cd /usr/lib/oracle/19.10/client64/lib \
&& ln -nsf libocci.so.19.1 libocci.so 
EXPOSE 8000-8999
