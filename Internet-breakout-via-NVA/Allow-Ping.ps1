New-NetFirewallRule -Name Allow_Ping -DisplayName 'Allow Ping' -Description 'Packet Internet Groper ICMPv4' -Protocol ICMPv4 -IcmpType 8 -Enabled True -Profile Any -Action Allow
