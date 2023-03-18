defmodule ExIpfsIpns.Key do
  @moduledoc """
  ExIpfsIpns.Key module handles creating, listing, renaming, and removing IPNS keys.

  Keys are what generates an IPNS name. The key is a cryptographic key pair, and the name is a hash of the public key. The name is what is used to resolve the IPNS name.
  """
  import ExIpfs.Utils

  alias ExIpfs.Api

  @enforce_keys [:name, :id]
  defstruct [:name, :id]

  @typedoc """
  Typespec for a key.
  """
  @type t :: %__MODULE__{
          name: binary(),
          id: binary()
        }

  @typedoc """
  Result from a rename operation.
  """
  @type rename :: %{
          id: binary(),
          was: binary(),
          now: binary(),
          overwrite: boolean()
        }

  @doc """
  Create a new keypair.

  ## Parameters
    `key` - Name of the key to generate.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-gen
  ```
  [
    type: <string>, # Key type.
    size: <int>, # Key size.
    ipns-base: <string>, # IPNS key base.
  ]
  ```
  """
  @spec gen!(binary, list) :: t() | Api.error_response()
  def gen!(key, opts \\ []) do
    Api.post_query("/key/gen?arg=" <> key, query: opts)
    |> new()
  end

  @spec gen(binary | list, list) :: {:ok, t} | Api.error_response()
  def gen(key, opts \\ [])

  def gen(key, opts) when is_binary(key) do
    gen!(key, opts)
    |> okify()
  end

  def gen(keys, opts) when is_list(keys) do
    Enum.map(keys, fn key -> gen!(key, opts) end)
    |> okify()
  end

  @doc """
  Returns the IPNS key for the given name.

  ## Parameters
  `name` - Name of the key to search for.
  `search_type` - Type of search criteria. Defaults to `:name
            If you want to search for the name of a key, use `:id`
            and provide the key id instead.
  """
  @spec get_or_create(binary(), atom) :: {:ok, t()} | ExIpfs.Api.error_response()
  def get_or_create(name, search_type \\ :name) do
    case ExIpfsIpns.Key.exists?(name) do
      true -> ExIpfsIpns.Key.search(name, search_type)
      false -> ExIpfsIpns.Key.gen(name)
    end
  end

  @doc """
  Import a key and prints imported key id.

  ## Parameters
  `key` - Name of the key to import.
  `name` - Name of the key to import.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-import
  ```
  [
    ipns-base: <string>, # IPNS key base.
    format: <string>, # Key format.
    allow-any-key-type: <bool>, # Allow any key type.
  ]
  ```
  """
  @spec import(binary(), binary(), list()) :: {:ok, any} | Api.error_response()
  def import(key, name, opts \\ []) do
    multipart_content(key)
    |> Api.post_multipart("/key/import?arg=" <> name, query: opts)
  end

  @doc """
  List all local keypairs.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-key-list
  ```
  [
    ipns-base: <string>, # IPNS key base.
  ]
  ```
  """
  @spec list(list()) :: {:ok, list(t())} | Api.error_response()
  def list(opts \\ []) do
    with %{"Keys" => keys} <- Api.post_query("/key/list", query: opts) do
      keys
      |> Enum.map(&new/1)
      |> okify()
    end
  end

  @doc """
  Search for a keypair.

  ## Parameters
  `key` - Name of the key to search for.
  `type` - Type of search criteria. Defaults to `:name
            If you want to search for the name of a key, use `:id`
            and provide the key id.
  """
  @spec search(binary, atom) :: any
  def search(key, type \\ :name) when is_atom(type) do
    with {:ok, keys} <- list() do
      case type do
        :name -> Enum.find(keys, fn k -> k.name == key end)
        :id -> Enum.find(keys, fn k -> k.id == key end)
      end
    end
  end

  @doc """
  Check if a keypair exists. This search both the name and id of the keypair.

  ## Parameters
  `key` - Name of the key to search for.
  `search_type` - Type of search criteria. Defaults to `:both`
            If you want to search for the `id` of a key, use `:name`
            and provide the key name.
            If you want to search for the `name` of a key, use `:id`
            and provide the key id.
  """
  @spec exists?(binary, atom) :: boolean
  def exists?(key, search_type \\ :both) when is_binary(key) do
    case search_type do
      :both -> search(key) != nil or search(key, :id) != nil
      :name -> search(key) != nil
      :id -> search(key, :id) != nil
    end
  end

  @doc """
  Rename a keypair.

  https://docs.ipfs.io/reference/http/api/#api-v0-key-rename

  ## Parameters
    `old` - Name of the key to rename.
    `new` - New name of the key.

  ## Options
  ```
  [
    ipns-base: <string>, # IPNS key base.
    force: <bool>, # Allow to overwrite existing key.
  ]
  ```
  """
  @spec rename(binary(), binary(), list()) :: {:ok, rename()} | Api.error_response()
  def rename(old, new, opts \\ []) do
    Api.post_query("/key/rename?arg=" <> old <> "&arg=" <> new, query: opts)
    |> rename()
    |> okify()
  end

  @doc """
  Remove a keypair.

  https://docs.ipfs.io/reference/http/api/#api-v0-key-rm

  ## Parameters
    `key` - Name of the key to remove.

    Also takes a list of keys to remove.

  ## Options
  ```
  [
    # ipns-base: <string>, # IPNS key base.
  ]
  ```
  """
  @spec rm!(binary(), list()) :: t() | Api.error_response()
  def rm!(key, opts \\ []) do
    Api.post_query("/key/rm?arg=" <> key, query: opts)
    |> new()
  end

  @spec rm(binary() | list(), list()) :: {:ok, t() | list(t())} | Api.error_response()

  def rm(keys, opts \\ [])

  def rm(key, opts) when is_binary(key) do
    rm!(key, opts)
    |> okify()
  end

  def rm(keys, opts) when is_list(keys) do
    Enum.map(keys, fn key -> rm!(key, opts) end)
    |> okify()
  end

  # HELPERS
  defp new({:error, data}), do: {:error, data}

  defp new(key) when is_map(key) do
    %__MODULE__{
      name: key["Name"],
      id: key["Id"]
    }
  end

  defp new(key) when is_binary(key) do
    %__MODULE__{
      name: key,
      id: nil
    }
  end

  @spec rename(any) :: rename() | Api.error_response()
  defp rename(data) do
    case data do
      {:error, response} ->
        {:error, response}

      rename ->
        %{
          id: rename["Id"],
          was: rename["Was"],
          now: rename["Now"],
          overwrite: rename["Overwrite"]
        }
    end
  end
end
