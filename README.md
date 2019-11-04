# apullo

[![Build Status](https://travis-ci.com/ninoseki/apullo.svg?branch=master)](https://travis-ci.com/ninoseki/apullo)
[![Coverage Status](https://coveralls.io/repos/github/ninoseki/apullo/badge.svg?branch=master)](https://coveralls.io/github/ninoseki/apullo?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/ninoseki/apullo/badge)](https://www.codefactor.io/repository/github/ninoseki/apullo)

![eyecatch](./images/eyecatch.png)

A scanner for taking basic fingerprints.

## Installation

```bash
gem install apullo
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
    }
  },
  "domain": {
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
    },
    "dns": {
      "ns": [
        "a.iana-servers.net",
        "b.iana-servers.net"
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
    }
  },
  "ssh": {
  },
  "meta": {
    "target": "https://example.com"
  }
}

$ apullo check jppost-be.top
{
  "http": {
    "body": {
      "md5": "74ad15c4ab3f67eee1d546e22248931f",
      "mmh3": -330759974,
      "sha1": "c0280893956852b0c07ae4da752ee5d776d248b8",
      "sha256": "28fa3b0beaf188d48b32557fa4df8f0aa451bd10f8e8bb26e919009d2d41b8fb"
    },
    "cert": {
    },
    "favicon": {
      "md5": "ad184c25a1a01d97696dcb59a1ffef74",
      "mmh3": 111036816,
      "sha1": "cb4842a54c3e96408765290cb810793302c17f0b",
      "sha256": "6949c58f841fa21a89e2e2375ae5645e1db62385f89a0218766f2b0a9c490fb8",
      "meta": {
        "url": "https://www.post.japanpost.jp/img/common/touch-icon.png"
      }
    }
  },
  "domain": {
    "whois": {
      "registrant_contacts": [

      ],
      "admin_contacts": [

      ],
      "technical_contacts": [

      ]
    },
    "dns": {
      "ns": [
        "ns1.bdydns.cn",
        "ns2.bdydns.cn"
      ],
      "cname": [

      ],
      "soa": [
        "sa.dudns.com"
      ],
      "mx": [

      ],
      "a": [
        "193.148.69.12"
      ],
      "aaaa": [

      ]
    }
  },
  "ssh": {
    "rsa": {
      "md5": "960bb068dbfb9aa9f9d6899c15844fca",
      "sha1": "d36555028decde1f931b47c90e469fc52e8f364a",
      "sha256": "cf3c7ea7b9442f71423f2253a9c0e448fd0d619e1abc7e519499cd789fac6e74"
    },
    "ecdsa-sha2-nistp256": {
      "md5": "551222e53a38c10817653a723e6caf0c",
      "sha1": "cd6044db29b30d35f32e26e74d66258570cd6527",
      "sha256": "0664dbea7580f9430da6d0ba13e7a4bba0f1efd449c895a6adcc147abc958ce6"
    },
    "ed25519": {
      "md5": "6da2245d9a211731c2d229ea7cce829b",
      "sha1": "d86afd8fca1a052249ef3a0ee26a24f6cc644485",
      "sha256": "7f0d4b642ea2c236eca4018a2dadff3b8a03c37745f9a9f741d9d246a420f358"
    }
  },
  "meta": {
    "target": "jppost-be.top"
  }
}
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
