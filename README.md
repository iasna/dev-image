# dev-image
The image contains
1. centos 8 as base image
2. gcc 8.3.1 (glibc 2.2.28 , glibcxx 2.2.28)
3. openssl 1.1.1
4. boost 1.75
5. zeromq 4.3.4
6. oracle 19c
7. wsdlpul 1.24
8. hiredis 1.0.0
9. cmake 3.2
10. supervisord 4.2.2
11. python3, python2 (nodev8)
12. nodev8

## How to build an image
```docker build . -t devimage```
or 
pull from docker hub
```docker pull asnaishrat/asna:v2```

## How to compile code
 ``` docker run --rm -u iris -v /home/asna:/home/iris -w /home/iris/Sparrow/Core/ -e LD_LIBRARY_PATH=/usr/local/lib:/home/iris/Sparrow/Core/cap/lib:/home/iris/Sparrow/Core/switch/lib:/usr/lib/oracle/19.10/client64/lib:/usr/local/lib64 sparrow-dev make -j2 ```
