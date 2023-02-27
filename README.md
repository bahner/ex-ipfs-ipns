# ExIpns

Elixir [IPNS][ipns] module. It is part of [ExIpfs][ex-ipfs] suite of modules.

[IPNS][ipns] provides mutable data structures in [IPFS][ipfs] by creating CIDs that are backed by PKI signing. As such they are self-certifying. A thought experiment could be to publish your GPG public key to your IPNS address. An IPNS address can be likened to a verified website with TLS, but where the signer is implicitly verified. Not as a legal entity, but as a key.

This module features both publication and key handling.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_ipns` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_ipns, "~> 0.0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ex_ipns>.

[ex-ipfs]: https://hex.pm/packages/ex_ipfs "Core Elixir IPFS module"
[ipfs]: https://ipfs.tech/ "Interplanetary File System"
[ipns]: https://docs.ipfs.tech/concepts/ipns/ "Interplanetary Name System"
