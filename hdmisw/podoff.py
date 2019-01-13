#!/usr/bin/env python3

from hdmisw import iog_factory

iog = iog_factory()
iog.set_power_on_detection(False)
iog.close()
