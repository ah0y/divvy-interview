defmodule HomeworkWeb.Resolvers.MerchantsResolver do
  alias Homework.Merchants
  alias Homework.Repo
  import Absinthe.Resolution.Helpers

  @doc """
  Get a list of merchants
  """
  def merchants(_root, args, _info) do
    Absinthe.Relay.Connection.from_query(
      Merchants.merchants_query(args),
      &Repo.all/1,
      args
    )
  end

  @doc """
  Get a merchant
  """
  def get_merchant(_, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Merchants, Merchants.Merchant, id)
    |> on_load(fn loader ->
      {:ok, Dataloader.get(loader, Merchants, Merchants.Merchant, id)}
    end)
  end

  @doc """
  Create a new merchant
  """
  def create_merchant(_root, args, _info) do
    case Merchants.create_merchant(args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not create merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a merchant for an id with args specified.
  """
  def update_merchant(_root, %{id: id} = args, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.update_merchant(merchant, args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not update merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a merchant for an id
  """
  def delete_merchant(_root, %{id: id}, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.delete_merchant(merchant) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not update merchant: #{inspect(error)}"}
    end
  end
end
