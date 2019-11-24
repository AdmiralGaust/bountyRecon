function getValueFromConfig() {
    echo `grep ${1} config.conf | cut -d '=' -f 2`
}

a=`getValueFromConfig "Recon_Home"`
echo `pwd`/${1}
