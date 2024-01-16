:: Disable LAN, enable wifi.
:: Change interface name with whatever Windows decided to call your ethernet and wifi adaptor
:: Used as dirty fix for Steam downloads wrecking IPTV while downloading anything at any speed over LAN.
:: Implement in task scheduler without triggers, then trigger from Stream Deck using BarRaiders Advanced Launcher
:: Application: C:\Windows\System32
:: Start in: C:\Windows\System32
:: Arguments: /RUN /TN "switchtolan"
netsh interface set interface "Ethernet" disable
netsh interface set interface "WiFi 3" enable