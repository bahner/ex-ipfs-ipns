# ExIpfsIpns

[![IPNS Unit and integration tests](https://github.com/bahner/ex-ipns/actions/workflows/testsuite.yaml/badge.svg)](https://github.com/bahner/ex-ipns/actions/workflows/testsuite.yaml)
[![Coverage Status](https://coveralls.io/repos/github/bahner/ex-ipns/badge.svg?branch=main)](https://coveralls.io/github/bahner/ex-ipns?branch=main)

Elixir [IPNS][ipns] module. It is part of [ExIpfs][ex-ipfs] suite of modules.

[IPNS][ipns] provides mutable data structures in [IPFS][ipfs] by creating CIDs that are backed by PKI signing. As such they are self-certifying. A thought experiment could be to publish your GPG public key to your IPNS address. An IPNS address can be likened to a verified website with TLS, but where the signer is implicitly verified. Not as a legal entity, but as a key.

This module features both publication and key handling.

## Usage

```elixir
  iex(1)> ExIpfsIpns.Key.gen("foo")
  {:ok,
    %ExIpfsIpns.Key{
      name: "foo",
      id: "k51qzi5uqu5dhxwb3x7bjg8k73tlkaqfugy217mgpf3vpdmoqn9du2qp865ddv"
    }}
  iex(2)> ExIpfsIpns.Name.publish("/ipfs/QmWGeRAEgtsHW3ec7U4qW2CyVy7eA2mFRVbk1nb24jFyks", key: "foo")
  {:ok,
    %ExIpfsIpns.Name{
      name: "k51qzi5uqu5dhxwb3x7bjg8k73tlkaqfugy217mgpf3vpdmoqn9du2qp865ddv",
      value: "/ipfs/QmWGeRAEgtsHW3ec7U4qW2CyVy7eA2mFRVbk1nb24jFyks"
    }}
```

  Then open your browser and browser to
  `ipns://k51qzi5uqu5dhxwb3x7bjg8k73tlkaqfugy217mgpf3vpdmoqn9du2qp865ddv/`

   Your browser does support IPFS, doesn't it? :-)

### Keys

In the above example the key `foo` is the identity of your website. If you lose the key, you can't update the "web site" again. Ever. But if you do keep it safe, your "web site" is proofably yours. Or - someone who has the key's.

*NB!* Outside the scope of this module or documentation it is possible to link this into the DNS namespace by using TXT RRs. Eg.

```DNS
_dnslink.myspace.bahner.com TXT dnslink=/ipns/k51qzi5uqu5dh36vwqrwttjcrwrl1ao5a8qx8rg851rrftqgso4x0ty586f68h
```

This way, if you lose the key, you can just point your DNS RR to the new id of a new key. So there is that.

See the [DNSLINK documentation][dnslink] for this.

[ex-ipfs]: https://hex.pm/packages/ex_ipfs "Core Elixir IPFS module"
[ipfs]: https://ipfs.tech/ "Interplanetary File System"
[ipns]: https://docs.ipfs.tech/concepts/ipns/ "Interplanetary Name System"
[dnslink]: https://dnslink.dev/ "Link IPFS resources to DNS"
