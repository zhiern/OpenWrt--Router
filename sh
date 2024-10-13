		用这个uci -q batch <<-EOF 
			set wireless.${name}=wifi-device
			set wireless.${name}.type=mac80211
			${dev_id}
			set wireless.${name}.channel=${channel}
			set wireless.${name}.band=${mode_band}
			set wireless.${name}.htmode=$htmode
			set wireless.${name}.disabled=0

			set wireless.default_${name}=wifi-iface
			set wireless.default_${name}.device=${name}
			set wireless.default_${name}.network=lan
			set wireless.default_${name}.mode=ap
			set wireless.default_${name}.ssid=MiFiR3G_${mode_band}  # 使用不同的SSID
			set wireless.default_${name}.encryption=psk2  # 设置加密
			set wireless.default_${name}.key=zj3753813  # WiFi密码
EOF替换		uci -q batch <<-EOF
			set wireless.${name}=wifi-device
			set wireless.${name}.type=mac80211
			${dev_id}
			set wireless.${name}.channel=${channel}
			set wireless.${name}.band=${mode_band}
			set wireless.${name}.htmode=$htmode
			set wireless.${name}.disabled=0

			set wireless.default_${name}=wifi-iface
			set wireless.default_${name}.device=${name}
			set wireless.default_${name}.network=lan
			set wireless.default_${name}.mode=ap
			set wireless.default_${name}.ssid=MiFiR3G
			set wireless.default_${name}.encryption=none
EOF使用sed -i方式
