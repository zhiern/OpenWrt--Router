#!/bin/bash
#=================================================
# ZrtoWrt's script
#================================================= 

##Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

##更换golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 23.x feeds/packages/lang/golang

##移除冲突文件
rm -rf feeds/packages/net/{xray*,v2ray*,sing-box*,brook*,chinadns-ng,*dns2socks*,dns2tcp*shadowsocks-libev,*shadowsocks-rust,*mosdns,*simple-obfs,*tcping,*trojan-go.*trojan,*trojan-plus,*tuic-client,*hysteria}
rm -rf feeds/packages/net/v2ray-geodata

##自定义页面
echo -e "\nmsgid \"Control\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"控制\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

echo -e "\nmsgid \"NAS\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"网络存储\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po


##配置IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate


##取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

##更改主机名
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate

##加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By Zero'/g" package/base-files/files/etc/openwrt_release
cp -f $GITHUB_WORKSPACE/scripts/banner package/base-files/files/etc/banner

sed -i "2iuci set istore.istore.channel='ZeroWrt_zero'" package/emortal/default-settings/files/99-default-settings
sed -i "3iuci commit istore" package/emortal/default-settings/files/99-default-settings


##New WiFi
sed -i "s/ImmortalWrt-2.4G/ZeroWrt-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
sed -i "s/ImmortalWrt-5G/ZeroWrt-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh


##更新FQ
rm -rf feeds/luci/applications/luci-app-passwall/*
rm -rf feeds/luci/applications/luci-app-ssr-plus/*
rm -rf feeds/luci/applications/luci-app-openclash/*
git clone --depth=1 https://github.com/kenzok8/small package/small

# iStore
git_sparse_clone main https://github.com/linkease/istore-ui app-store-ui
git_sparse_clone main https://github.com/linkease/istore luci


##定时设置
git clone --depth=1 https://github.com/sirpdboy/luci-app-autotimeset package/luci-app-autotimeset


./scripts/feeds update -a
./scripts/feeds install -a

./scripts/feeds update -a
./scripts/feeds install -a
