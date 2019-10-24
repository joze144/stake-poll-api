defmodule DockerStakeService.AccountTest do
  @moduledoc false
  use DockerStakeService.DataCase

  alias DockerStakeService.Account
  alias DockerStakeService.UserRepo

  describe "Account tests" do
    test "Create account" do
      public_address = random_string(15)

      assert {:ok, %UserRepo{}} = Account.register(public_address)
      assert {:ok, %UserRepo{}} = Account.register(public_address)
    end
  end

  defp random_string(length) do
    length |> :crypto.strong_rand_bytes() |> Base.url_encode64() |> binary_part(0, length)
  end
end
