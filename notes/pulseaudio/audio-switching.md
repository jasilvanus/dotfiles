# PulseAudio switching from CLI

## Listing

```bash
pacmd list-sinks | grep -C2 name:
pacmd list-sources | grep -C2 name:
```

## Setting Defaults

```bash
pacmd set-default-sink $name
pacmd set-default-output $name
```

This requires adding this line to `/etc/pulse/default.pa`, see https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/DefaultDevice/:

```config
load-module module-stream-restore restore_device=false
```
