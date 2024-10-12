#!/bin/bash

# 个性化设置
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/MI-R3G/' package/base-files/files/bin/config_generate

# 调整菜单位置
sed -i "s|services|system|g" feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json

# turboacc 补丁
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

# 安装插件
./scripts/feeds update -l
./scripts/feeds install -a
