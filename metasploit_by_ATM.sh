apt install -y ./ruby.deb
gem install lolcat
lolcat timewarn.sh
echo -e "\e[34m Depending On Your Network Speed\e[0m"
Sleep 6.0
cd
echo -e "\e[34mREMOVING OLD METASPLOIT FOLDER(if any)....\e[0m"
rm -rf metasploit-framework
echo -e "\e[34mINSTALLING....\e[0m"
echo -e "\e[34mPACKAGES BEING INSTALLED WAIT....\e[0m"
pkg update -y 
pkg upgrade -y
echo -e "\e[34mPLEASE WAIT THIS CAN TAKE UP TO 5 MINUTES....\e[0m"
apt install -y libiconv zlib autoconf bison clang coreutils curl findutils git apr apr-util libffi libgmp libpcap postgresql readline libsqlite openssl libtool libxml2 libxslt ncurses pkg-config wget make libgrpc termux-tools ncurses-utils ncurses unzip zip tar termux-elf-cleaner
echo -e "\e[34mPACKAGES INSTALLED SUCCESSFULLY....[\e[92m✓\e[34m]\e[0m"
echo -e "\033[92m"
echo -e "\e[34mINSTALLING METASPLOIT....\e[0m"
#!/data/data/com.termux/files/usr/bin/bash

# Remove  Old Folder if exist 
find $HOME -name "metasploit-*" -type d -exec rm -rf {} \;


cwd=$(pwd)
msfvar=6.0.33
msfpath='/data/data/com.termux/files/home'

apt update && apt upgrade
# Temporary 
apt remove ruby -y
apt install -y libiconv zlib autoconf bison clang coreutils curl findutils git apr apr-util libffi libgmp libpcap postgresql readline libsqlite openssl libtool libxml2 libxslt ncurses pkg-config wget make ruby2 libgrpc termux-tools ncurses-utils ncurses unzip zip tar termux-elf-cleaner
# Many phones are claiming libxml2 not found error
ln -sf $PREFIX/include/libxml2/libxml $PREFIX/include/

#ruby 2.7.x
apt install -y ./ruby.deb

cd $msfpath
curl -LO https://github.com/rapid7/metasploit-framework/archive/$msfvar.tar.gz

tar -xf $msfpath/$msfvar.tar.gz
mv $msfpath/metasploit-framework-$msfvar $msfpath/metasploit-framework
cd $msfpath/metasploit-framework

# Update rubygems-update
if [ "$(gem list -i rubygems-update 2>/dev/null)" = "false" ]; then
	gem install --no-document --verbose rubygems-update
fi

# Update rubygems
update_rubygems

# Install bundler
gem install --no-document --verbose bundler:1.17.3

# Installing all gems 
bundle config build.nokogiri --use-system-libraries
bundle install -j3
echo "Gems installed"

# Some fixes
sed -i "s@/etc/resolv.conf@$PREFIX/etc/resolv.conf@g" $msfpath/metasploit-framework/lib/net/dns/resolver.rb
find "$msfpath"/metasploit-framework -type f -executable -print0 | xargs -0 -r termux-fix-shebang
find "$PREFIX"/lib/ruby/gems -type f -iname \*.so -print0 | xargs -0 -r termux-elf-cleaner

echo "Creating database"

mkdir -p $msfpath/metasploit-framework/config && cd $msfpath/metasploit-framework/config
curl -LO https://raw.githubusercontent.com/avistnm/Metasploit-avistnm/main/database.yml

mkdir -p $PREFIX/var/lib/postgresql
pg_ctl -D "$PREFIX"/var/lib/postgresql stop > /dev/null 2>&1 || true

if ! pg_ctl -D "$PREFIX"/var/lib/postgresql start --silent; then
    initdb "$PREFIX"/var/lib/postgresql
    pg_ctl -D "$PREFIX"/var/lib/postgresql start --silent
fi
if [ -z "$(psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='msf'")" ]; then
    createuser msf
fi
if [ -z "$(psql -l | grep msf_database)" ]; then
    createdb msf_database
fi

rm $msfpath/$msfvar.tar.gz

cd

chmod 777 msfconsole
mv msfconsole /data/data/com.termux/files/usr/bin
ln -sf $(which msfconsole) $PREFIX/bin/msfvenom

#Remove Ruby
apt remove ruby -y

#Install Ruby
cd
apt install -y ./ruby.deb
apt install -y ./rubyarm.deb

#lolcat
gem install lolcat

cd
rm ruby.deb
rm rubyarm.deb
rm README.md
rm -rf Metasploit-avistnm
rm -f metasploit_by_ATM.sh
rm -rf msfvenom
rm -f database.yml

echo -e "\e[1;34m Fixing in Progress..... \e[0m"
cd
apt remove -y ruby
cd metasploit-framework
bundle config build.nokogiri --use-system-libraries 
bundle install
bundle update
echo -e "\e[1;34m Fixing Over!! \e[0m"
rm -f timewarn.sh
sleep 6.0
clear
lolcat credit.sh
rm -f credit.sh
echo -e "\e[1;32m                    Installed!! \e[0m"
echo -e "\e[1;34m Now you can directly use msfvenom or msfconsole rather than ./msfvenom or ./msfconsole \e[0m"
