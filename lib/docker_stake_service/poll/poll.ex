defmodule DockerStakeService.Poll do
  @moduledoc false

  alias DockerStakeService.{PollRepo, VoteRepo}

  require Logger

  @type poll_id :: String.t()
  @type title :: String.t()
  @type option :: String.t()
  @type user_id :: String.t()
  @type option_id :: String.t()
  @type token_id :: String.t()

  @spec get_poll(poll_id, user_id) :: Map.t() | nil
  def get_poll(poll_id, user_id) do
    poll_id
    |> PollRepo.get_poll_by_id()
    |> calculate_votes()
    |> case do
         nil ->
           nil
         e ->
           Map.put(e, :user_vote, VoteRepo.get_for_poll_and_user(poll_id, user_id))
       end
  end

  @spec vote_on_poll(user_id, poll_id, option_id) :: {:ok, Map.t()} | {:error, nil}
  def vote_on_poll(user_id, poll_id, option_id) do
    with {:ok, _} <- VoteRepo.insert_vote(user_id, poll_id, option_id, 1) do
      {:ok, get_poll(poll_id, user_id)}
    else
      e ->
        Logger.error("Problem voting on the poll: #{inspect(e)}")
        {:error, nil}
    end
  end

  @spec create_poll(poll_id, title, [option], token_id, user_id) :: {:ok, Map.t()} | {:error, String.t()}
  def create_poll(poll_id, title, options, token_id, user_id)
      when is_list(options) and options != [] and title != nil and title != "" do
    with nil <- PollRepo.get_poll_by_id(poll_id),
         {:ok, %{poll_insert: _}} <- PollRepo.create_poll_transaction(poll_id, title, options, token_id) do
      {:ok, PollRepo.get_poll_by_id(poll_id) |> calculate_votes(), VoteRepo.get_for_poll_and_user(poll_id, user_id)}
    else
      %{} = entry ->
        {:ok, entry}

      error ->
        Logger.error("Problem creating poll: #{inspect(error)}")
        {:error, :unhandled}
    end
  end

  def create_poll(_, _, _, _), do: {:error, :bad_request}

  defp calculate_votes(nil), do: nil

  defp calculate_votes(%{poll_id: poll_id, poll_options: poll_options} = poll) do
    votes = VoteRepo.get_weight_sum_for_poll_options(poll_id)
    votes_sum = sum_votes(votes)

    full_votes =
      votes
      |> Enum.map(fn %{vote_weight: weight} = data ->
        if weight == 0 do
          Map.merge(data, %{vote_percentage: "0.0"})
        else
          Map.merge(data, %{vote_percentage: :erlang.float_to_binary((weight * 100) / votes_sum, [decimals: 1])})
        end
      end)

    full_poll_options =
      poll_options
      |> Enum.map(fn %{poll_option_id: po_id} = option ->
        case Enum.find(full_votes, fn %{poll_option_id: p_id} -> p_id == po_id end) do
          %{} = v ->
            Map.merge(option, v)

          nil ->
            Map.merge(option, %{vote_percentage: "0", vote_weight: 0})
        end
      end)

    Map.put(poll, :poll_options, full_poll_options)
  end

  defp sum_votes(votes) when is_list(votes) and votes != [] do
    votes
    |> Enum.reduce(0, fn %{vote_weight: weight}, acc ->
      acc + weight
    end)
  end

  defp sum_votes(_), do: 0
end
