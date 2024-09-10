# Restic backup Home Assistant addon

## About

In supervised setup, the Home Assistant `systemmonitor` integration cannot guarantee to monitor every partion, because not everyone is mounted in the "homeassistant" container.

In some special cases, e.g. if using different disks for `media` or `backup`, this may be problematic. This is where this addon comes into play. It mounts all available directories and allows to query disk usage for any directory.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Add Add this URL to your Home Assistant addons repos (Supervisor -> Add-on store -> three dots upper right): `https://github.com/baflo/home-assistant-addons`
1. Install this add-on.
1. Check boot on startup.
1. Start the add-on.

## Sensor setup

In Home Assistant helpers, you can configure a template sensor to get the latest backup date(s):

```
{{ state_attr("sensor.restic_addon_snapshots", "snapshots") | sort(attribute="time", reverse=True) | unique("map", attribute="path") | map(attribute="time") | first }} 
```