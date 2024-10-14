#!/bin/bash

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 更换golang版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

# 科学上网插件
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash

# 主题
git clone --depth=1 -b master https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

# 网速控制
git clone --depth=1 https://github.com/oppen321/luci-app-eqos package/eqos

# 个性化设置
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/MI-R3G/' package/base-files/files/bin/config_generate
sed -i 's/o\.default = 'bing';/o.default = 'none';/' package/luci-app-argon-config/htdocs/luci-static/resources/view/argon-config.js
cp -f $GITHUB_WORKSPACE/images/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 修改WiFi名称
sed -i 's/set wireless.default_${name}.ssid=OpenWrt/set wireless.default_${name}.ssid=XiaomiR3G/' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 开启Wifi
sed -i 's/set wireless.${name}.disabled=1/set wireless.${name}.disabled=0/' package/kernel/mac80211/files/lib/wifi/mac80211.sh



# 调整菜单位置
sed -i "s|services|system|g" feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json

# turboacc 补丁
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

# 安装插件
./scripts/feeds update -l
./scripts/feeds install -a
