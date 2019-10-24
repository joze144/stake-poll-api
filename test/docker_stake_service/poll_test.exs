defmodule DockerStakeService.PollTest do
  @moduledoc false

  use DockerStakeService.DataCase

  alias DockerStakeService.Factory
  alias DockerStakeService.Poll

  @eth_token_id "8bb6fd41-dc57-405f-87da-e372bc511efe"

  describe "Poll tests" do
    test "Create poll" do
      options = ["first", "second", "third"]
      assert {:ok, %{}} =
               Poll.create_poll(Ecto.UUID.generate(), "Fancy poll", options, @eth_token_id)
    end

    test "Bad case" do
      # No options
      options = []
      assert {:error, :bad_request} ==
               Poll.create_poll(Ecto.UUID.generate(), "Fancy poll", options, @eth_token_id)

      options = ["first", "second", "third"]
      # No title
      assert {:error, :bad_request} ==
               Poll.create_poll(Ecto.UUID.generate(), nil, options, @eth_token_id)

      # Double request
      poll_id = Ecto.UUID.generate()
      assert {:ok, %{}} =
               Poll.create_poll(poll_id, "Fancy poll", options, @eth_token_id)
      assert {:ok, %{}} =
               Poll.create_poll(poll_id, "Fancy poll", options, @eth_token_id)
    end
  end

  test "Poll with votes" do
    %{id: user_id} = Factory.insert!(:user)
    %{id: user_id2} = Factory.insert!(:user)
    %{id: user_id3} = Factory.insert!(:user)
    options = ["first", "second", "third"]
    {:ok, %{poll_id: poll_id, poll_options: [%{poll_option_id: po_id1}, %{poll_option_id: po_id2} | _]}} =
      Poll.create_poll(Ecto.UUID.generate(), "Fancy poll", options, @eth_token_id)

    Poll.vote_on_poll(user_id, poll_id, po_id1)
    Poll.vote_on_poll(user_id2, poll_id, po_id2)
    Poll.vote_on_poll(user_id3, poll_id, po_id1)
  end
end
