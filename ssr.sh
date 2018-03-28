#!/bin/bash

#去掉最后一行的逗号
function rmComma(){
numOfBracket=$(sed -n '/\}\,/=' /root/shadowsocksr/user-config.json)
`sed -in "$((numOfBracket-1))s/\,//" /root/shadowsocksr/user-config.json`
}

#添加用户的函数
function addUser(){
echo "输入端口号(1024~65535)"
read port
while test $(grep -c "\"$port\"" /root/shadowsocksr/user-config.json) -ne 0
do
echo "这个端口已被使用"
echo "再次输入端口号(1024~65535)"
read port
done
while test $port -lt 1024 -o $port -gt 65535
do
echo "端口号的范围必须是1024～65535"
echo "再次输入端口号(1024~65535)"
read port
done
echo "输入密码"
read password
echo "是否添加用户\"$port\":\"$password\" y/n"
read confirm
if [ "$confirm"="y" ]
then
`sed -i "/\"port_password\":{/a\	\"$port\":\"$password\"," /root/shadowsocksr/user-config.json`
fi
}

#删除用户的函数
function deleteUser(){
echo "输入你要删除用户的端口号"
read port
isTrue=$(grep -c "\"$port\":" /root/shadowsocksr/user-config.json)
if [ $isTrue -ne 0 ]
then
$(sed -i "/\"$port\"/d" /root/shadowsocksr/user-config.json)
else
echo "没有这个用户端口号"
fi
}

#查看用户的方法
function showUser(){
users=$(grep -o '\"[0-9]\{4,\}\":.*' /root/shadowsocksr/user-config.json)
for x in $users
do
echo $x
done
}

#加密的方法
function encryptMethod(){
encryptType=("none" "table" "rc4" "rc4-md5" "rc4-md5-6" "aes-128-cfb" "aes-192-cfb" "aes-256-cfb" "aes-128-ctr" "aes-192-ctr" "aes-256-ctr" "bf-cfb" "camellia-128-cfb" "camellia-192-cfb" "camellia-256-cfb" "salsa20" "chacha20" "chahca20-ietf")
num=1
while test $num -le ${#encryptType[*]}
do
echo "$num : ${encryptType[$((num-1))]}"
num=`expr $num + 1`
done
echo "选择你的加密方法"
read numOfEncrypt
echo "你选择的加密方法是${encryptType[$((numOfEncrypt-1))]}  y/n"
read confirm
if test "$comfirm"="y"
then
`sed -i "s/\"method\":.*\",/\"method\":\"${encryptType[$((numOfEncrypt-1))]}\",/" /root/shadowsocksr/user-config.json`
fi 
}

#修改协议的方法
function protocol(){
protocols=("origin" "verify_simple" "verify_sha1" "auth_sha1" "auth_sha1_v2" "auth_sha1_v4" "auth_aes128_sha1" "auth_aes128_md5" "auth_chain_a")
num=1
for x in ${protocols[@]}
do
echo "$num $x"
num=`expr $num + 1`
done
echo "选择你的协议"
read numOfprotocols
echo "你选择的协议是${protocols[$((numOfprotocols-1))]}  y/n"
read confirm
if test "$confirm"="y"
then
`sed -i "s/\"protocol\":.*\",/\"protocol\":\"${protocols[$((numOfprotocols-1))]}\",/" /root/shadowsocksr/user-config.json`
fi
}

#修改混淆的方法
function obfs(){
obfss=("plain" "http_simple" "http_post" "tls_simple" "tls1.2_ticket_auth")
num=1
for x in ${obfss[@]}
do
echo "$num : $x"
num=`expr $num + 1`
done
echo "选择你的混淆插件"
read numOfobfss
echo "你选择的混淆是 ${obfss[$((numOfobfss-1))]}  y/n"
read confirm
if test "$confirm"="y"
then
`sed -i "s/\"obfs\":.*\",/\"obfs\":\"${obfss[$((numOfobfss-1))]}\",/" /root/shadowsocksr/user-config.json`
fi
}

#查看配置的方法
function showConfig(){
printf "`cat -n /root/shadowsocksr/user-config.json`"
printf "\n"
}

#启动ssr
function logrun(){
`chmod +x /root/shadowsocksr/shadowsocks/logrun.sh`
. /root/shadowsocksr/shadowsocks/logrun.sh
}

#停止ssr
function stopssr(){
`chmod +x /root/shadowsocksr/shadowsocks/logrun.sh`
. /root/shadowsocksr/shadowsocks/stop.sh
}

#查看日志
function showTail(){
`chmod +x /root/shadowsocksr/shadowsocks/tail.sh`
. /root/shadowsocksr/shadowsocks/tail.sh
}

#`apt-get install vim git -y`
#`git clone -b manyuser https://github.com/ToyoDAdoubi/shadowsocksr.git`
#bash ./shadowsocksr/initcfg.sh
while :
do
isPortPassword=$(grep -c "\"port_password\"" /root/shadowsocksr/user-config.json)
if [ $isPortPassword -eq 0 ]
then
`sed -i "/\"local_port\"/a\    \"port_password\":{" /root/shadowsocksr/user-config.json`
`sed -i "/\"port_password\":{/a\    }," /root/shadowsocksr/user-config.json`
fi
echo "======================================"
echo "1:添加用户"
echo "2:删除用户"
echo "3:查看用户"
echo "4:加密方法"
echo "5:修改协议"
echo "6:修改混淆"
echo "7:查看配置"
echo "8:运行ssr"
echo "9:停止ssr"
echo "q:退出"
echo "t:查看日志"
echo "======================================"
read choose
case $choose in
1)addUser
rmComma
showUser
continue
;;
2)deleteUser
rmComma
showUser
continue
;;
3)showUser
continue
;;
4)encryptMethod
continue
;;
5)protocol
continue
;;
6)obfs
continue
;;
7)showConfig
continue
;;
8)logrun
continue
;;
9)stopssr
continue
;;
q)break
;;
t)showTail
continue
;;
*)echo "welcome came"
continue
;;
esac
done
