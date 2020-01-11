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
      "serial": 21020869104500376438182461249190639870,
      "sha1": "7bb698386970363d2919cc5772846984ffd4a889",
      "sha256": "9250711c54de546f4370e0c3d3a3ec45bc96092a25a4a71a1afa396af7047eb8"
    },
    "favicon": {
    },
    "headers": {
      "cache-control": "max-age=604800",
      "content-type": "text/html; charset=UTF-8",
      "date": "Sat, 11 Jan 2020 10:47:09 GMT",
      "etag": "\"3147526947+gzip\"",
      "expires": "Sat, 18 Jan 2020 10:47:09 GMT",
      "last-modified": "Thu, 17 Oct 2019 07:18:26 GMT",
      "server": "ECS (oxr/830F)",
      "vary": "Accept-Encoding",
      "x-cache": "HIT",
      "content-length": "648"
    },
    "meta": {
      "url": "https://example.com",
      "links": {
        "shodan": {
          "body": "https://www.shodan.io/search?query=http.html_hash%3A-2087618365",
          "cert": "https://www.shodan.io/search?q=ssl.cert.serial%3A21020869104500376438182461249190639870"
        },
        "censys": {
          "body": "https://censys.io/ipv4?q=ea8fac7c65fb589b0d53560f5251f74f9e9b243478dcb6b3ea79b5e36449c8d9",
          "cert": "https://censys.io/ipv4?q=9250711c54de546f4370e0c3d3a3ec45bc96092a25a4a71a1afa396af7047eb8"
        }
      }
    }
  },
  "domain": {
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
    },
    "meta": {
      "links": {
        "securitytrails": "https://securitytrails.com/domain/example.com/dns"
      }
    }
  },
  "ssh": {
  },
  "meta": {
    "target": "https://example.com"
  }
}

$ apullo check jppost-ku.com
{
  "http": {
    "body": {
      "md5": "0728450344e6ea95107ce8c3b00f10ae",
      "mmh3": 421543491,
      "sha1": "6fa29d366b33d5f3c54d62c95b23aa1cce2587a3",
      "sha256": "7bc86f6a3d8877bd84d9917c3661658867af3fdb44842b973be2d299fe793dc2"
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
    },
    "headers": {
      "server": "Apache-Coyote/1.1",
      "accept-ranges": "bytes",
      "etag": "W/\"54423-1577193448000\"",
      "last-modified": "Tue, 24 Dec 2019 13:17:28 GMT",
      "content-type": "text/html",
      "content-length": "54423",
      "date": "Sat, 11 Jan 2020 10:48:28 GMT"
    },
    "meta": {
      "url": "http://jppost-ku.com",
      "links": {
        "shodan": {
          "body": "https://www.shodan.io/search?query=http.html_hash%3A421543491",
          "favicon": "https://www.shodan.io/search?query=http.favicon.hash%3A111036816"
        },
        "censys": {
          "body": "https://censys.io/ipv4?q=7bc86f6a3d8877bd84d9917c3661658867af3fdb44842b973be2d299fe793dc2"
        }
      }
    }
  },
  "domain": {
    "dns": {
      "ns": [
        "ns2.bdydns.cn",
        "ns1.bdydns.cn"
      ],
      "cname": [

      ],
      "soa": [
        "sa.dudns.com"
      ],
      "mx": [

      ],
      "a": [
        "45.10.90.113"
      ],
      "aaaa": [

      ]
    },
    "whois": {
      "registrant_contacts": [

      ],
      "admin_contacts": [

      ],
      "technical_contacts": [

      ]
    },
    "meta": {
      "links": {
        "securitytrails": "https://securitytrails.com/domain/jppost-ku.com/dns"
      }
    }
  },
  "ssh": {
    "rsa": {
      "md5": "565c74c34ca3a4a44625e8cbf732bed5",
      "sha1": "2fb4d2241f7b6dd83c376548a794d5e903ce2b64",
      "sha256": "e97b6fa7a9c3cb00919fbe90d862b08c2b4b1ac8c09701a0bb063e47ae764160"
    },
    "ecdsa-sha2-nistp256": {
      "md5": "59e75650c592742fbe54a56140965af6",
      "sha1": "1cddc49647d0e3cd5fefcc15e41fa036651ba903",
      "sha256": "54a7bcac7ac7c2ffc501396dd1ae68b0c7f7b3a627c813c0020822b7a01e6a69"
    },
    "ed25519": {
      "md5": "5ca62c892f4cb1c3197b245b2e1b9254",
      "sha1": "9bbcfec876f80c831a9ace061dfa7ba7d207c2d2",
      "sha256": "e7c2073b8ae07dea059307eb4d1f435c92d25228e5def49075e8007f5cb44765"
    },
    "meta": {
      "links": {
        "shodan": "https://www.shodan.io/search?query=port%3A22+56%3A5c%3A74%3Ac3%3A4c%3Aa3%3Aa4%3Aa4%3A46%3A25%3Ae8%3Acb%3Af7%3A32%3Abe%3Ad5",
        "censys": "https://censys.io/ipv4?q=54a7bcac7ac7c2ffc501396dd1ae68b0c7f7b3a627c813c0020822b7a01e6a69"
      }
    }
  },
  "meta": {
    "target": "jppost-ku.com"
  }
}
```

## Notes

- `mmh3` is a 32 bit signed int value of MurmurHash3.
- Keys of `http.headers` are downcased.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
