yay -S openvpn
yay -S networkmanager-openvpn
yay -S unzip
cd /etc/openvpn
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
unzip openvpn.zip
vim us_east.ovpn

# add to bottom:
auth-user-pass pass.txt

# start
sudo openvpn us_east.ovpn
