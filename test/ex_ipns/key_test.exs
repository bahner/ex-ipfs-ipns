defmodule ExIpns.KeyTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpns.Key

  test "generate and remove key" do
    key = "exipns-test-gen-remove"

    if Key.exists?(key) do
      assert {:ok, _} = Key.rm(key)
    end

    assert {:ok, _} = Key.gen(key)
    assert {:ok, _} = Key.rm(key)
  end

  test "generate and remove a list of keys" do
    gen_remove_keys = ["gen-remove-1", "gen-remove-2", "gen-remove-3"]
    try do
      Key.rm(gen_remove_keys)
    catch
      _ -> :ok
    end
    assert {:ok, _} = Key.gen(gen_remove_keys)
    assert {:ok, _} = Key.rm(gen_remove_keys)
  end

  test "rename a key" do
    rename_key = "exipns-test-rename"
    overwrite_key = "exipns-test-overwrite"

    unless Key.exists?(rename_key) do
      assert {:ok, _} = Key.gen(rename_key)
    end
    unless Key.exists?(overwrite_key) do
      assert {:ok, _} = Key.gen(overwrite_key)
    end
    assert catch_error(Key.rename(rename_key, overwrite_key))
    assert {:ok, _} = Key.rename(rename_key, overwrite_key, force: true)
  end
end
