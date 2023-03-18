defmodule ExIpfsIpns do
  @moduledoc """
  Interplanetary Name System commands
  """
  import ExIpfs.Utils

  alias ExIpfs.Api

  @enforce_keys [:name, :value]
  defstruct [:name, :value]

  @type t :: %__MODULE__{
          name: binary(),
          value: binary()
        }

  @doc """
  Publish IPNS names.

  ## Parameters
    `path` - Path to be published.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-name-publish
  ```
  [
    resolve: <bool>, # Resolve given path before publishing.
    lifetime: <string>, # Time duration that the record will be valid for.
    allow-offline: <bool>, # Run offline.
    ttl: <string>, # Time duration this record should be cached for (caution: experimental).
    key: <string>, # Name of the key to be used or a valid PeerID, as listed by 'ipfs key list -l'.
    ipns-base: <string>, # IPNS key base.
  ]
  ```

  ## Example
  ```
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
  """
  @spec publish(Path.t(), list()) :: {:ok, any} | ExIpfs.Api.error_response()
  def publish(path, opts \\ []) when is_binary(path) do
    Api.post_query("/name/publish?arg=" <> path, query: opts)
    |> new!()
    |> okify()
  end

  @doc """
  Resolve IPNS names.

  ## Parameters
    `name` - IPNS name to resolve.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-name-resolve
  ```
  [
    recursive: <bool>, # Resolve until the result is not an IPNS name.
    nocache: <bool>, # Do not use cached entries.
    dht-record-count: <int>, # Number of records to request for DHT resolution.
    dht-timeout: <string>, # Maximum time to collect values during DHT resolution eg "30s".
    stream: <bool>, # Stream the output as a continuous series of JSON values.
  ]
  ```
  """
  @spec resolve(Path.t(), list) :: {:ok, any} | Api.error_response()
  def resolve(path, opts \\ []),
    do:
      Api.post_query("/name/resolve?arg=" <> path, query: opts)
      |> okify()

  defp new!(map) when is_map(map) do
    %__MODULE__{
      name: map["Name"],
      value: map["Value"]
    }
  end

  defp new!({:error, data}), do: {:error, data}
end
