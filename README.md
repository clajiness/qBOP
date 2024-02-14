# qBOP
A tool for keeping ProtonVPN, OPNsense, and qBittorrent ports in sync.

## Purpose
This tool helps automate port forwarding from ProtonVPN to qBittorrent via OPNsense. The tool polls ProtonVPN for the given forwarded port, checks the port set in OPNsense and qBittorrent, and updates it if necessary.

## Requirements
* Linux distro such as Debian, Ubuntu, etc, or a Mac.
* Ruby 3+ (tested with 3.2.2)
* natpmpc (Linux - `apt install natpmpc`) or libnatpmp (Mac - `brew install libnatpmp`)
* ProtonVPN subscription
* OPNsense - This is the tutorial I used to set up selective routing to ProtonVPN. https://docs.opnsense.org/manual/how-tos/wireguard-selective-routing.html
* qBittorrent

## Config
Clone the qBOP repo to your machine. Copy the file `config.yml.example`, rename it to `config.yml` with `cp config.yml.example config.yml`, and enter the required values.
1. `loop_freq:` This value determines how often the script runs. The default value is 45 seconds. This probably shouldn't be changed.
2. `proton_gateway:` The IP address of your ProtonVPN gateway. For example, `10.2.0.1`.
3. `opnsense_interface_addr:` The IP address of your OPNsense interface. For example, `https://10.1.1.1`.
4. `opnsense_api_key:` Your OPNsense API key - https://docs.opnsense.org/development/how-tos/api.html
5. `opnsense_api_secret:` Your OPNsense API secret
6. `opnsense_alias_name:` The firewall alias that you use for ProtonVPN's forwarded port. For example, `proton_vpn_forwarded_port`.
7. `qbit_addr:` The IP address of your qBittorrent app. For example, `http://10.1.1.100:8080`.
8. `qbit_user:` Your qBittorrent username
9. `qbit_pass:` Your qBittorrent password

Next, you must start the script. You can manually start it, if you wish, with `ruby qbop.rb`. I'd recommend setting it up to start on boot, though. I've included an example systemd service file for those on Linux.

**Needless to say, I'm not responsible for what you use this script for.**
