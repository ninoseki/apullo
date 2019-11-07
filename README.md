# apullo

[![Gem Version](https://badge.fury.io/rb/apullo.svg)](https://badge.fury.io/rb/apullo)
[![Build Status](https://travis-ci.com/ninoseki/apullo.svg?branch=master)](https://travis-ci.com/ninoseki/apullo)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ninoseki/apullo)](https://hub.docker.com/r/ninoseki/apullo)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/apullo/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/apullo?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/apullo/badge)](https://www.codefactor.io/repository/github/ninoseki/apullo)

![eyecatch](https://raw.githubusercontent.com/ninoseki/apullo/master/images/eyecatch.png)

A scanner for taking basic fingerprints.

## Installation

```bash
gem install apullo
# or
docker pull ninoseki/apullo
```

## Usage

```bash
$ apullo
Commands:
  apullo check [Target]  # Take fingerprints from a target(IP, domain or URL)
  apullo help [COMMAND]  # Describe available commands or one specific command

```

It takes basic network fingerprints of a target.

- Hashes of an HTTP response body
- Headers of an HTTP response
- Hashes of an SSL certificate
- Hashes of a favicon image
- Hashes of an SSH host key
- DNS records
- WHOIS registrant data

```bash
$ apullo check https://example.com
{
  "http": {
    "body": {
      "md5": "84238dfc8092e5d9c0dac8ef93371a07",
      "mmh3": -2087618365,
      "sha1": "4a3ce8ee11e091dd7923f4d8c6e5b5e41ec7c047",
      "sha256": "ea8fac7c65fb589b0d53560f5251f74f9e9b243478dcb6b3ea79b5e36449c8d9"
    },
    "cert": {
      "md5": "3510c21c66bd62010fc547d3cd3f0ce6",
      "serial": "21020869104500376438182461249190639870",
      "sha1": "7bb698386970363d2919cc5772846984ffd4a889",
      "sha256": "9250711c54de546f4370e0c3d3a3ec45bc96092a25a4a71a1afa396af7047eb8"
    },
    "favicon": {
    },
    "headers": {
      "accept-ranges": "bytes",
      "cache-control": "max-age=604800",
      "content-type": "text/html; charset=UTF-8",
      "date": "Thu, 07 Nov 2019 23:21:43 GMT",
      "etag": "\"3147526947+gzip\"",
      "expires": "Thu, 14 Nov 2019 23:21:43 GMT",
      "last-modified": "Thu, 17 Oct 2019 07:18:26 GMT",
      "server": "ECS (sec/9739)",
      "vary": "Accept-Encoding",
      "x-cache": "HIT",
      "content-length": "648"
    },
    "meta": {
      "url": "https://example.com"
    }
  },
  "domain": {
    "dns": {
      "ns": [
        "b.iana-servers.net",
        "a.iana-servers.net"
      ],
      "cname": [

      ],
      "soa": [
        "noc.dns.icann.org"
      ],
      "mx": [

      ],
      "a": [
        "93.184.216.34"
      ],
      "aaaa": [
        "2606:2800:220:1:248:1893:25C8:1946"
      ]
    },
    "whois": {
      "registrant_contacts": [
        {
          "id": null,
          "type": 1,
          "name": null,
          "organization": "Internet Assigned Numbers Authority",
          "address": null,
          "city": null,
          "zip": null,
          "state": null,
          "country": null,
          "country_code": null,
          "phone": null,
          "fax": null,
          "email": null,
          "url": null,
          "created_on": null,
          "updated_on": null
        }
      ],
      "admin_contacts": [

      ],
      "technical_contacts": [

      ]
    }
  },
  "ssh": {
  },
  "meta": {
    "target": "https://example.com"
  }
}
```

## Notes

- `mmh3` is a 32 bit signed int value of MurmurHash3.
- Keys of `http.headers` are downcased.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
