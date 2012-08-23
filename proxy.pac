function FindProxyForURL(url, host) {
	var proxyString;
	if (dnsDomainIs(host, ".generalmills.com")      ||
	    dnsDomainIs(host, ".genmills.com")          ||
		isInNet(host, "146.217.0.0", "255.255.0.0") ||
		isInNet(host, "10.0.0.0", "255.255.255.0")  ||
		isInNet(host, "172.16.0.0", "255.240.0.0")  ||
		isInNet(host, "192.168.0.0", "255.255.0.0")) {
		proxyString = "DIRECT";
	} else {
		proxyString = "SOCKS5 localhost:8080";
	}
	return proxyString;
}
