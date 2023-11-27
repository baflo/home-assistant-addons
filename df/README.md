# df Home Assistant Addon

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

In Home Assistant `configuration.yaml`, you must configure sensors to request the actual disk usage. That may look as follows:

```
rest:
  - resource: "http://d5097817-df:1234/backup"
    sensor:
      - name: "Backup Disk Usage"
        value_template: "{{ value_json.used }}"
        unit_of_measurement: "MiB"
        unique_id: backup_disk_usage

      - name: "Backup Disk Available"
        value_template: "{{ value_json.available }}"
        unit_of_measurement: "MiB"
        unique_id: backup_disk_available

      - name: "Backup Disk Usage Percent"
        value_template: "{{ value_json.percent }}"
        unit_of_measurement: "%"
        unique_id: backup_disk_percent
  - resource: "http://d5097817-df:1234/config"
    sensor:
      - name: "Config Disk Usage"
        value_template: "{{ value_json.used }}"
        unit_of_measurement: "MiB"
        unique_id: config_disk_usage

      - name: "Config Disk Available"
        value_template: "{{ value_json.available }}"
        unit_of_measurement: "MiB"
        unique_id: config_disk_available

      - name: "Config Disk Usage Percent"
        value_template: "{{ value_json.percent }}"
        unit_of_measurement: "%"
        unique_id: config_disk_percent
  - resource: "http://d5097817-df:1234/media/MEDIA"
    sensor:
      - name: "Media Disk Usage"
        value_template: "{{ value_json.used }}"
        unit_of_measurement: "MiB"
        unique_id: media_disk_usage

      - name: "Media Disk Available"
        value_template: "{{ value_json.available }}"
        unit_of_measurement: "MiB"
        unique_id: media_disk_available

      - name: "Media Disk Usage Percent"
        value_template: "{{ value_json.percent }}"
        unit_of_measurement: "%"
        unique_id: media_disk_percent
```
