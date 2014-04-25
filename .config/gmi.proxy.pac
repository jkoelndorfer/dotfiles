function FindProxyForURL(url, host) {
	var proxyString;
	var resolvedIp = dnsResolve(host);
	if (
		isPlainHostName(host)                             ||
		dnsDomainIs(host, ".generalmills.com")            ||
		dnsDomainIs(host, ".genmills.com")                ||
		dnsDomainIs(host, ".fishnetsecurity.com")         ||
		dnsDomainIs(host, ".emc.com")                     ||
		dnsDomainIs(host, ".ibm.com")                     ||
		dnsDomainIs(host, ".hp.com")                      ||
		dnsDomainIs(host, ".oracle.com")                  ||
		dnsDomainIs(host, ".sap.com")                     ||
		isInNet(resolvedIp, "146.217.0.0", "255.255.0.0") ||
		isInNet(resolvedIp, "153.13.0.0", "255.255.0.0")  ||
		isInNet(resolvedIp, "10.0.0.0", "255.0.0.0")      ||
		isInNet(resolvedIp, "172.16.0.0", "255.240.0.0")  ||
		isInNet(resolvedIp, "192.168.0.0", "255.255.0.0")) {
		proxyString = "DIRECT";
	} else {
		proxyString = "SOCKS5 localhost:8080";
	}
	return proxyString;
}
