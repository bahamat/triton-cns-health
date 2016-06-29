# triton-cns-health

A health checker for [Triton CNS][triton-cns].

[triton-cns]: https://docs.joyent.com/public-cloud/network/cns

## How it works

Put your own custom health check scripts into `check.d`. The filename must
end with `.sh`. If any check script exits with non-zero status the metadata
key `triton.cns.status` will be set to `down`. If all checks return `0` status
then `triton.cns.status` will be set to `up`.

## Set up

    git clone https://joyent.com/bahamat/triton-cns-health
    cd triton-cns-health
    ./install

Don't forget to add health check scripts to `check.d`!

## License

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0.
