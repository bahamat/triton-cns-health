# triton-cns-health

A health checker for [Triton CNS][triton-cns].

[triton-cns]: https://docs.joyent.com/public-cloud/network/cns

## How it works

Put your own custom health check scripts into `check.d`. The filename must
end with `.sh`. If any check script exits with non-zero status the metadata
key `triton.cns.status` will be set to `down`. If all checks return `0` status
then `triton.cns.status` will be set to `up`.

This removes service host names (e.g., `name.svc.cust_uuid.cns.example.com`)
when status is set to down and adds them when status is set to up.

## Set up

    git clone https://joyent.com/bahamat/triton-cns-health
    cd triton-cns-health
    ./install

Don't forget to add health check scripts to `check.d`!

### A note about provisioning

When provisioning, if you include a `triton.cns.services` tag you should also
include `triton.cns.status=disabled` to avoid the dns name being available
before the instance is ready to serve production traffic.

Here's an example using the [triton cli][node-triton].

    triton create base-64-lts g4-highcpu-2G --name www1 \
        --tag triton.cns.services=www \
        --metadata='{"triton.cns.status": "down"}'

[node-triton]: https://github.com/joyent/node-triton

For full automation you should use a `user-script` to bootstrap your
deployement system which should then install all services as well as the
health checker along with appropriate health check scripts.

## License

This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0.
