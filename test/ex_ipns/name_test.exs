defmodule ExIpns.NameTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpns.Name
  alias ExIpns.Key

  @key "exipns-name-test-key"

  unless Key.exists?(@key) do
    assert {:ok, _} = Key.gen("exipns-test")
  end

  test "publish" do
    assert {:ok, _} =
             Name.publish(
               "/ipfs/Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z",
               key: @key
             )
  end
end
