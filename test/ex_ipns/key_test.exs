defmodule ExIpfsIpns.KeyTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfsIpns.Key

  test "generate and remove key" do
    key = "exipns-test-gen-remove"
    Key.rm(key)

    assert {:ok, _} = Key.gen(key)
    assert {:ok, _} = Key.rm(key)
  end

  test "generate and remove a list of keys" do
    gen_remove_keys = ["gen-remove-1", "gen-remove-2", "gen-remove-3"]

    Key.rm(gen_remove_keys)

    assert {:ok, _} = Key.gen(gen_remove_keys)
    assert {:ok, _} = Key.rm(gen_remove_keys)
  end

  test "rename a key" do
    rename_key = "exipns-test-rename"
    overwrite_key = "exipns-test-overwrite"

    Key.gen([rename_key, overwrite_key])

    assert {:error, %ExIpfs.ApiError{}} = Key.rename(rename_key, overwrite_key)
    assert {:ok, rename} = Key.rename(rename_key, overwrite_key, force: true)

    assert rename.was == rename_key
    assert rename.now == overwrite_key
    assert rename.overwrite == true
  end

  test "search for keys" do
    search_key = "search-1"
    non_existent_key = "search-2-fjhdlslfdghslfdh"

    Key.gen(search_key)
    Key.rm(non_existent_key)

    result = Key.search(non_existent_key, :name)
    assert is_nil(result)
    result = Key.search(non_existent_key, :id)
    assert is_nil(result)

    result = Key.search(search_key, :id)
    assert is_nil(result)
    assert %ExIpfsIpns.Key{} = Key.search(search_key, :name)
    result = Key.search(search_key, :name)
    assert %ExIpfsIpns.Key{} = result
    assert result.name == search_key
    assert not is_nil(result.id)

    Key.rm(search_key)
  end
end
