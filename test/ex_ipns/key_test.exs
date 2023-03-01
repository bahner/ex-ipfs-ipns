defmodule ExIpns.KeyTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpns.Key

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
end
