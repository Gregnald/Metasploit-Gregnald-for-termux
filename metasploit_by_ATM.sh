apt update -y >/dev/null 2>&1
apt upgrade -y >/dev/null 2>&1

#arch check
arc=$(dpkg --print-architecture)

#ruby remove
apt remove -y ruby >/dev/null 2>&1

#ruby 2.7.0 install
cd >/dev/null 2>&1
if [[ $arc = "aarch64" ]];
then
apt install -y --allow-downgrades ./ruby.deb >/dev/null 2>&1
elif [[ $arc = "arm" ]];
then
apt install -y --allow-downgrades ./rubyarm.deb >/dev/null 2>&1
else
break;
fi

#lolcat
gem install lolcat >/dev/null 2>&1

lolcat timewarn.sh
echo -e "\e[34m Depending On Your Network Speed\e[0m"
sleep 6.0
cd
echo -e "\e[34mREMOVING OLD METASPLOIT FOLDER(if any)....\e[0m"
# Remove  Old Folder if exist 
find $HOME -name "metasploit-*" -type d -exec rm -rf {} \; >/dev/null 2>&1

echo -e "\e[34mINSTALLING METASPLOIT....\e[0m"
#!/data/data/com.termux/files/usr/bin/bash


cwd=$(pwd)
msfvar=6.0.37
msfpath='/data/data/com.termux/files/home'

# Temporary 
apt install -y libiconv zlib autoconf bison clang coreutils curl findutils git apr apr-util libffi libgmp libpcap postgresql readline libsqlite openssl libtool libxml2 libxslt ncurses pkg-config wget make libgrpc termux-tools ncurses-utils ncurses unzip zip tar termux-elf-cleaner > /dev/null 2>&1
# Many phones are claiming libxml2 not found error
ln -sf $PREFIX/include/libxml2/libxml $PREFIX/include/ > /dev/null 2>&1

cd $msfpath
curl -LO https://github.com/rapid7/metasploit-framework/archive/refs/tags/$msfvar.tar.gz > /dev/null 2>&1

tar -xf $msfpath/$msfvar.tar.gz  > /dev/null 2>&1
mv $msfpath/metasploit-framework-$msfvar $msfpath/metasploit-framework  > /dev/null 2>&1
cd $msfpath/metasploit-framework

# Update rubygems-update
if [ "$(gem list -i rubygems-update 2>/dev/null)" = "false" ]; then
	gem install --no-document --verbose rubygems-update > /dev/null 2>&1
fi

# Update rubygems
update_rubygems > /dev/null 2>&1

# Install bundler
gem install --no-document --verbose bundler:1.17.3 > /dev/null 2>&1


# Some fixes
sed -i "s@/etc/resolv.conf@$PREFIX/etc/resolv.conf@g" $msfpath/metasploit-framework/lib/net/dns/resolver.rb > /dev/null 2>&1
find "$msfpath"/metasploit-framework -type f -executable -print0 | xargs -0 -r termux-fix-shebang > /dev/null 2>&1
find "$PREFIX"/lib/ruby/gems -type f -iname \*.so -print0 | xargs -0 -r termux-elf-cleaner > /dev/null 2>&1

echo "Creating database"

mkdir -p $msfpath/metasploit-framework/config && cd $msfpath/metasploit-framework/config > /dev/null 2>&1
curl -LO https://raw.githubusercontent.com/avistnm/Metasploit-avistnm/main/database.yml > /dev/null 2>&1

mkdir -p $PREFIX/var/lib/postgresql > /dev/null 2>&1
pg_ctl -D "$PREFIX"/var/lib/postgresql stop > /dev/null 2>&1 || true

if ! pg_ctl -D "$PREFIX"/var/lib/postgresql start --silent; then
    initdb "$PREFIX"/var/lib/postgresql > /dev/null 2>&1
    pg_ctl -D "$PREFIX"/var/lib/postgresql start --silent > /dev/null 2>&1
fi
if [ -z "$(psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='msf'")" ]; then
    createuser msf > /dev/null 2>&1
fi
if [ -z "$(psql -l | grep msf_database)" ]; then
    createdb msf_database > /dev/null 2>&1
fi

rm $msfpath/$msfvar.tar.gz > /dev/null 2>&1

cd

ln -s $HOME/metasploit-framework/msfconsole /data/data/com.termux/files/usr/bin/ > /dev/null 2>&1
ln -s $HOME/metasploit-framework/msfvenom /data/data/com.termux/files/usr/bin/ > /dev/null 2>&1

echo -e "\e[1;34m Fixing in Progress..... \e[0m"
cd metasploit-framework
bundle config build.nokogiri --use-system-libraries  > /dev/null 2>&1
bundle install -j3 > /dev/null 2>&1
bundle update > /dev/null 2>&1
echo -e "\e[1;34m Fixing Over!! \e[0m"
cd
rm ruby.deb
rm rubyarm.deb
rm README.md
rm -rf Metasploit-avistnm
rm -f metasploit_by_ATM.sh
rm -rf msfvenom
rm -f database.yml
rm -f timewarn.sh
clear
lolcat credit.sh
rm -f credit.sh
echo -e "\e[1;32m                    Installed!! \e[0m"
echo -e "\e[1;34m Now you can directly use msfvenom or msfconsole rather than ./msfvenom or ./msfconsole \e[0m"
