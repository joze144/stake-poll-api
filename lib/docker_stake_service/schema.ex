defmodule DockerStakeService.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @timestamps_opts [type: :naive_datetime_usec]
      @foreign_key_type Ecto.UUID
    end
  end
end
