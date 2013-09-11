function FindProxyForURL(url, host) {
	var resolvedIp = dnsResolve(host);
	var proxyString;
	if (dnsDomainIs(host, ".facebook.com")                ||
	    dnsDomainIs(host, ".linkedin.com")                ||
	    dnsDomainIs(host, ".hulu.com")                    ||
	    dnsDomainIs(host, ".netflix.com")                 ||
	    dnsDomainIs(host, ".youtube.com")                 ||
	    dnsDomainIs(host, ".gmail.com")                   ||
	    dnsDomainIs(host, ".google.com")                  ||
	    dnsDomainIs(host, ".generalmills.com")            ||
	    dnsDomainIs(host, ".minecraftforum.net")          ||
		isInNet(resolvedIp, "10.0.0.0", "255.255.255.0")  ||
		isInNet(resolvedIp, "172.16.0.0", "255.240.0.0")  ||
		isInNet(resolvedIp, "192.168.0.0", "255.255.0.0")) {
		proxyString = "DIRECT";
	} else {
		proxyString = "SOCKS5 localhost:8080";
	}
	return proxyString;
}
