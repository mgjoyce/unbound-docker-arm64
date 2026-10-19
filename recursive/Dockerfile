# The 1.24.2 image from this repository, unchanged except that it resolves recursively instead of forwarding to
# Cloudflare over TLS. Everything else (access control: loopback and private ranges only, DNSSEC validation,
# hardening) is the base image's own configuration.
#
# The base is pinned by digest so this image is reproducible; move it deliberately when a new base is published.
ARG BASE=ghcr.io/mgjoyce/unbound-docker-arm64@sha256:f7ba44c3321db02accb8909b2911ee5b4682877ea3229caee114f3b6acc32936
FROM ${BASE}
COPY forward-records.conf /opt/unbound/etc/unbound/forward-records.conf
