defmodule ExIpnsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpns.Key

  @key "exipns-ExIpns-test-key"

  test "publish" do
    Key.gen(@key)

    assert {:ok, _} =
             ExIpns.publish(
               "/ipfs/Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z",
               key: @key
             )
  end
end
