# The 1.24.2 image from this repository with two changes, so it resolves recursively the way Unbound behind a
# Pi-hole does:
#   1. no forward-zone — recursion from the root servers instead of forwarding to Cloudflare over TLS;
#   2. use-caps-for-id: no — the base image turns 0x20 case randomisation on, and a number of authoritative servers
#      (bbc.co.uk, reddit.com, stripe.com, ubuntu.com … in testing) answer such queries in a way Unbound then rejects, so
#      without forwarding ~a third of first lookups ended in SERVFAIL. Pi-hole's own Unbound recipe turns it off.
# Everything else (access control: loopback and private ranges only, DNSSEC validation, hardening) is the base image.
#
# The base is pinned by digest so this image is reproducible; move it deliberately when a new base is published.
ARG BASE=ghcr.io/mgjoyce/unbound-docker-arm64@sha256:f7ba44c3321db02accb8909b2911ee5b4682877ea3229caee114f3b6acc32936
FROM ${BASE}
COPY forward-records.conf /opt/unbound/etc/unbound/forward-records.conf
# unbound.sh writes unbound.conf on first start, from a heredoc that carries this line; change it there and fail the
# build if the line is not found (a future base that renames it must not silently skip this).
RUN sed -i 's/use-caps-for-id: yes/use-caps-for-id: no/' /unbound.sh && grep -q 'use-caps-for-id: no' /unbound.sh
