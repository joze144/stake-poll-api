defmodule DockerStakeService.Factory do
  alias DockerStakeService.UserRepo
  alias DockerStakeService.Repo

  defp random_string(length) do
    length |> :crypto.strong_rand_bytes() |> Base.url_encode64() |> binary_part(0, length)
  end

  def build(:user) do
    %UserRepo{
      public_address: random_string(6),
      nonce: DateTime.utc_now() |> DateTime.to_unix()
    }
  end

  def build(factory_name, attrs) do
    factory_name |> build() |> struct(attrs)
  end

  def insert!(factory_name, attrs \\ %{}) do
    Repo.insert!(build(factory_name, attrs))
  end
end
