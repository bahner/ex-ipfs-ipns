defmodule ExIpfsIpnsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfsIpns.Key

  @tag timeout: :infinity
  @key "exipns-ExIpfsIpns-test-key"

  test "publish" do
    Key.gen(@key)

    assert {:ok, _} =
             ExIpfsIpns.publish(
               "/ipfs/Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z",
               key: @key
             )
  end
end
