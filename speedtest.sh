
node_now=$(cat /etc/config/shadowsocksr |grep global_server|sed -e 's/\toption global_server//'  -e  "s/'cfg0//" -e "s/4a8f'//")

case $[$node_now*1] in 
6)
echo  -e "当前节点:hostdare\n"
;;
7)
echo -e  "当前节点:vultr\n"
;;
8)
echo -e  "当前节点:ocp\n"
;;
9)
echo -e  "当前节点:aws\n"
;;
*)
echo  -e  "当前节点:其他\n"
;;
esac




echo "1、仅测速"
echo "7、vultr"
echo "6、hostdae"
echo "8、ocp"
echo "9、aws"
echo "0、测速并替换"

if read  -t 5 -p "请设置使用的代理:" node_assign
then
echo "已选择节点"$node_assign
else
node_assign=0
fi

case $node_assign in 
	7)
		echo "设置节点"
		sed  -i  's/cfg..4a8f/cfg074a8f/'  /etc/config/shadowsocksr
		/etc/init.d/shadowsocksr restart
		echo "设置完成"
	;;
	#hostdare
	6)
		echo "设置节点"

		sed  -i  's/cfg..4a8f/cfg064a8f/'  /etc/config/shadowsocksr
		/etc/init.d/shadowsocksr restart
		echo "设置完成"
	;;
	# ocp
	8)
		echo "设置节点"

		sed  -i  's/cfg..4a8f/cfg084a8f/'  /etc/config/shadowsocksr
		/etc/init.d/shadowsocksr restart
		echo "设置完成"
	;;
	#aws
	9)
		echo "设置节点"

		sed  -i  's/cfg..4a8f/cfg094a8f/'  /etc/config/shadowsocksr
		/etc/init.d/shadowsocksr restart
		echo "设置完成"
	;;
	0)
		echo -e "\n启动测速并替换"
		curl https://speedtest.anycast.eu.org/500MB.swf -o /dev/null >log.txt --max-time 15 2>&1
		aa=$(cat log.txt |tr '\r' '\n' | awk '{print $NF}'| sed '$d'|tail -n 1)
		aa=$(cat log.txt |tr '\r' '\n' | awk '{print $NF}'| sed '$d'|tail -n 1|sed 's/k//g')
		echo $node_string $'\t' >>speedtest.log
		echo $(date +%D)"  "$(date +%T)$'\t'$aa >>speedtest.log
		echo $node_string $(date +%D)"  "$(date +%T)$'\t'$aa 
		if  [ $aa -lt 1500 ]; then
			sed  -i  's/cfg..4a8f/cfg064a8f/'  /etc/config/shadowsocksr
			/etc/init.d/shadowsocksr restart
			echo "更换为hostdare节点" >>speedtest.log
			echo "更换为hostdare节点" 
		fi

	;;
	1)
		
		echo -e "\n启动测速"
		curl https://speedtest.anycast.eu.org/500MB.swf -o /dev/null >log.txt --max-time 15 2>&1
		aa=$(cat log.txt |tr '\r' '\n' | awk '{print $NF}'| sed '$d'|tail -n 1)
		aa=$(cat log.txt |tr '\r' '\n' | awk '{print $NF}'| sed '$d'|tail -n 1|sed 's/k//g')
		echo $(date +%D)"  "$(date +%T)$'\t'$aa
		;;
	*)
		echo "无效输入，退出"

		;;
esac
