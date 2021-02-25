cd
pkg update -y -n -n
pkg upgrade -y
echo  "INSTALLING REQUIREED PACKAGES"
echo -e "\e[34mPACKAGES BEING INSTALLED WAIT....\e[0m"
apt remove -y ruby
apt install -y libiconv zlib autoconf bison clang coreutils curl findutils git apr apr-util libffi libgmp libpcap postgresql readline libsqlite openssl libtool libxml2 libxslt ncurses pkg-config wget make libgrpc termux-tools ncurses-utils ncurses unzip zip tar termux-elf-cleaner > /dev/null 2>&1
echo -e "\e[34mPACKAGES INSTALLED SUCCESSFULLY....[\e[92m✓\e[34m]\e[0m"
echo -e "\033[92m"
center "INSTALLING  METASPLOIT"
echo -e "\e[34mINSTALLING METASPLOIT....\e[0m"
cd $HOME
ln -sf $PREFIX/include/libxml2/libxml $PREFIX/include/
ver='6.0.27'
cd
apt-mark unhold ruby
curl -LO https://github.com/rapid7/metasploit-framework/archive/$ver.tar.gz
cd
tar -xf $ver.tar.gz
cd
cp ruby.deb
cd
apt install -y ./ruby.deb
apt-mark hold ruby
cd /metasploit-framework
bundle config build.nokogiri --use-system-libraries 
bundle update
cd
echo "Creating database"

mkdir -p metasploit-framework/config && cd metasploit-framework/config
curl -LO https://raw.githubusercontent.com/Hax4us/Metasploit_termux/master/database.yml

cd

mkdir -p $PREFIX/var/lib/postgresql
pg_ctl -D "$PREFIX"/var/lib/postgresql stop || true

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

mv metasploit-framework-6.0.27 metasploit-framework

cd

chmod 777 msfconsole
chmod 777 msfvenom
mv msfconsole /data/data/com.termux/files/usr/bin
mv msfvenom /data/data/com.termux/files/usr/bin

rm $ver.tar.gz

clear
echo "            Installed!!"
echo " you can directly use msfvenom or msfconsole rather than ./msfvenom or ./ms"
sleep 4.0
clear
msfconsole