COMMAND=(
  eval touch mkdir chmod dd rm chown mv cp chattr kill killall pkill reboot su sudo exit cat clear sleep
)

echo "请输入需要解密的脚本路径: "
read -r FILE_PATH

for i in "${COMMAND[@]}"; do
  alias $i="echo"
done

if [[ ! -f $FILE_PATH ]]; then
  echo "找不到指定文件！"
else
  RESULT=$(. $FILE_PATH)
  LAST_RESULT=""

  for r in $RESULT; do
    LAST_RESULT=$r
  done

  if [[ $LAST_RESULT == "" ]]; then
    echo "缺少关键参数，无法解密！"
  else
    if [[ -f ./kpi.txt || $(du ./kpi | cut -f1) -ne 0 ]]; then
      alias eval="eval"
      . $FILE_PATH
      # kpi 写在这里
      KPI=""
      if [[ $KPI == "" ]]; then
        echo "请输入关键参数！"
      else
        echo "$KPI" >./waste.sh
        LINE=1
        MAX_LINE=$(wc -l ./waste.sh | awk -F " " '{print $1}')
        READ=$(sed -n "${LINE}p" ./waste.sh)
        while [[ $(echo $READ | grep "eval") == "" ]]; do
          let LINE++
          READ=$(sed -n "${LINE}p" ./waste.sh)
          if [[ $LINE -gt $MAX_LINE ]]; then
            echo "找不到指定字段！"
            FAIL="true"
            break
          fi
        done
        if [[ $FAIL != "true" ]]; then
          let LINE--
          while [[ $LINE -gt 1 ]]; do
            sed -i "${LINE}d" ./waste.sh
            let LINE--
          done
          alias eval="echo"
          . ./waste.sh >./mingwen.sh
        fi
      fi
    else
      LAST_RESULT=${LAST_RESULT//\"/}
      echo -n $LAST_RESULT >./kpi.txt
      echo "请退出脚本，复制 kpi 文件内容至本脚本 KPI 变量内！"
    fi
  fi
fi
