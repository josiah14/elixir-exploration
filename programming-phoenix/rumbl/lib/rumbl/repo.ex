defmodule Rumbl.Repo do
  @moduledoc """
  In memory repository.
  """

  def get(module, id) do
    Enum.find all(module), fn map -> map.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end

  def all(Rumbl.User) do
    [%Rumbl.User{id: "1", name: "Josiah", username: "jberkebi", password: "pass"},
     %Rumbl.User{id: "2", name: "Joanna", username: "jannaberkebi", password: "me"},
     %Rumbl.User{id: "3", name: "Donald", username: "dtrump", password: "make america great again"}]
  end

  def all(_module), do: []
end
