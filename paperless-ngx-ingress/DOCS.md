# Paperless-ngx

_Paperless is an application that manages your personal documents. With the help of a document scanner (see [Scanner recommendations](https://paperless-ngx.readthedocs.io/en/latest/scanners.html#scanners)), paperless transforms your wieldy physical document binders into a searchable archive and provides many utilities for finding and managing your documents._

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Add Add this URL to your Home Assistant addons repos (Supervisor -> Add-on store -> three dots upper right): `https://github.com/baflo/home-assistant-addons`
1. Install this add-on.
1. Set the configuration.
    1. Set admin user and password
1. Click the `Save` button to store your configuration.
1. Start the add-on.
1. Check the logs of the add-on to see if everything went well.

## Access

This addon is accessible from ingress and may also be configured to be accessed externally. It provides two access ports:

- Port `666` is reserved to be used by Home Assistant's internal ingress. It makes use of the `REMOTE_USER` header to log in to paperless automatically, if accessed through the embedded UI. **Do not expose this on the internet. Users could write their own `REMOTE_USER` header.**
- Port `8000` can be used for external access, e.g. you can configure [cloudflared](https://github.com/brenner-tobias/addon-cloudflared/) to point to it. Don't forget to add your external host to the config. This entry removes the `REMOTE_USER` header so it cannot be used externally.
- Internally, paperless runs on port 8888, but it's bound to address 127.0.0.1, so you cannot access it from outside of the container.

## File Storage

The *consumption directory* is located in `share/paperless` and should be published so files can be placed there.

The `data` and `media` directories are located in the addon's private `data` directory.

## Backing up

The simplest way to make a backup is to make a Home Assistant backup and include the addon's data.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

```yaml
admin:
  username: superuser
  password: superpassword
consumption:
  dir: paperless
  recursively: false
  subdirsAsTags: false
login: admin
hosts:
  - host: http://homeassistant.local:8123
```

### Option: `admin.username`, `admin.password`

The default superuser that will be created after startup if no superuser has been created, yet.

### Option: `consumption.dir`

The path to the `consumption` directory within the `share` directory.

### Option: `login`

May be `admin`, `auto` or `manual` and regards the login to the paperless embedded in the Home Assistant UI. It does not apply to a external access.

For `admin` the embedded paperless instance will always be opened with the user as configured in `admin.username`. 

For `auto` the embedded paperless instance will always be opened with the user that is logged in to Home Assistant. This depends on [#4152](https://github.com/home-assistant/supervisor/pull/4152).

For `manual` the user must log in as usual even in embedded UI.

### Option: `hosts`

List of allowed external hosts.





