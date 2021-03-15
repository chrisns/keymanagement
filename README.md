# How I manage my keys

Use a spare raspberry pi3b+ I had spare

## Preparation

1. Download [raspbian](https://downloads.raspberrypi.org/raspios_full_armhf/images/raspios_full_armhf-2020-12-04/2020-12-02-raspios-buster-armhf-full.zip) `SHA512:271f319347999d203265cb56625bfa3646e9497f6d030e182ea20ada7152fe66cfb6f65d80a1cb7d8e269c315aa9f0a1845ecc160745a5ae3953eb686aaa4b3f` and write to a SD card

1. `touch /boot/ssh` so that it boots headless with ssh enabled, optionally add a `wpa_supplicant.conf` for the next step to run

1. `docker run --rm -ti --net=host -v $PWD:/app quay.io/openshift/origin-ansible:v4.8.0@sha256:c6eac2186cb5aa34f56941001f62b834973d3bbc60a0940ebe7d143755c37fb4 -- ansible-playbook -i raspberrypi.local, /app/playbook.yaml -u pi -f 1 --ask-pass` (mdns .local resolution will work if its the only pi and your network allows it)

## Usage

1. plug the pi into a screen and keyboard with [**NO NETWORK**](https://google.com) (though the ansible should have disabled that)

1. set the time on the pi

1. `/home/pi/scripts/create_masterkey.exp` it will ask for name and email address

1. `/home/pi/scripts/create_subkeys.exp` to create the subkeys

1. `/home/pi/scripts/create_identity.exp foo@example.com` to add email addresses to the key

1. `/home/pi/scripts/export_keys.exp` to export the keys and make QR code copies

1. `/home/pi/scripts/copykeys_to_yubikey.exp`

1. `/home/pi/scripts/configure_yubikey.exp` to set the pins on tke key

1. `/home/pi/scripts/copy_to_usb.sh` to copy the material to usb sticks

## Renewal

Renewal of keys is pretty simple, if my yubikey is plugged in on boot, it will add **12 months** to the expiry and then shut down, you'll know its done when the lights go out.

This means if I loose my yubikey it only has a maximum of 12 months life before it wouldn't be useful if a revocation either doesn't work or isn't respected for example with ssh authentication.

I would like to reduce that to something shorter, but I'm going to see how annoying it is with 12 months to start with.

## Revocation

If I loose a key, revocation and adding a new key is possible by booting the offline raspberry pi without a yubikey thus avoiding it attempting the renewal process.

## Disaster recovery

If the master and/or sub keys are irrecoverable from the SD card or USB Stick, a paper backup exists and has been securely distributed and stored at a few different locations to aid in the recovery.

To recover the paperkey, a new raspberry pi image will need to be created following the steps in this repo and and use the raspicam to capture the key for restoration to the keychain.

## References

- https://gist.github.com/joostrijneveld/59ab61faa21910c8434c
- https://github.com/nurupo/paper-store
- https://github.com/balos1/easy-gpg-to-paper
- https://keyoxide.org/guides
- https://gist.github.com/ageis/14adc308087859e199912b4c79c4aaa4
