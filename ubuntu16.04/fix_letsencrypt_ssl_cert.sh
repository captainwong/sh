#!/bin/bash

# https://letsencrypt.org/zh-cn/docs/dst-root-ca-x3-expiration-september-2021/
# https://medium.com/geekculture/will-you-be-impacted-by-letsencrypt-dst-root-ca-x3-expiration-d54a018df257

sed -i 's/mozilla\/DST_Root_CA_X3.crt/!mozilla\/DST_Root_CA_X3.crt/g' /etc/ca-certificates.conf
update-ca-certificates
