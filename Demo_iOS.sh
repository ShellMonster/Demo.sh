#!/bin/bash
#for_道长（Q_1013373636）


#=====================执行环境说明=====================#
#1，请安装fastlane工具，使用Hhomebrew安装；
#2，请修改执行路径为独立项目内根目录；
#4，请先在xcode创建“muban”的target；


echo "####= = = 欢迎使用 = = ="
echo "####= = = 如有其他问题欢迎在博客内留言= = = "
echo "for_道长（Q_1013373636）"

#获取项目路径，及文件夹名字（请保证scheme=文件夹名称=项目名称）；
Pwd_Name=`pwd`;Project_Name=${Pwd_Name##*/};

#变量，此处已固定，无需更改；
scheme="${Project_Name}"
plist_PATH="./${scheme}/Info.plist"
ipafile="./${scheme}.ipa"

#User=""

#切换执行路径，确保无误；
cd `pwd`

echo "###获取CFBundleVersion值并在每次打包时加1"
CFBundleVersion=`defaults read ${Pwd_Name}/${scheme}/Info CFBundleVersion`
echo ${CFBundleVersion}
new_CFBundleVersion=`expr ${CFBundleVersion} + 1`
echo ${new_CFBundleVersion}

#修改plist文件build号；
sed -i "" "/>CFBundleVersion</{n;s/>[^<>]*</>${new_CFBundleVersion}</;}" ${plist_PATH}

#删除fastlane元数据文件及截图文件，确保每次均能打包提审；
rm -rf fastlane/metadata
rm -rf fastlane/screenshots
rm -rf fastlane/Fastfile
rm -rf fastlane/Appfile
#添加提审规则；
rule="  submission_information({
      content_rights_contains_third_party_content: false,
      export_compliance_contains_third_party_cryptography: false,
      export_compliance_uses_encryption: false,
      add_id_info_uses_idfa: true,
      add_id_info_serves_ads: true,
      add_id_info_tracks_action: true,
      add_id_info_tracks_install: true,
      add_id_info_limits_tracking: true,
      export_compliance_uses_encryption: false,
      export_compliance_encryption_updated: false,
      })"
echo ${rule} >>Deliverfile

echo "###以下为打包字段，等待即可"
fastlane gym --workspace "${scheme}.xcworkspace" --scheme "${scheme}" --clean

echo "###以下为上传ipa字段，等待即可"
fastlane deliver --ipa "${ipafile}" --submit_for_review --force true --automatic_release false #-u #"${User}"

#以下为fir打包及上传命令，可自行修改调用
#fir build_ipa path/to/workspace -w -S BiZhi -o path/to/output -p -c "this is changelog" -Q -T xxxxxxxxxxxxxxxxxxxxx

#以下为蒲公英上传命令，可自行修改调用
#curl -F "file=@/Users/mac/Desktop/path/path.ipa" -F "uKey=xxxxxxxxxxxxxx" -F "_api_key=xxxxxxxxxxxx" https://qiniu-storage.pgyer.com/apiv1/app/upload
