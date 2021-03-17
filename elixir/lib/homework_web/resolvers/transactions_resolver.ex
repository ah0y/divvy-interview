defmodule HomeworkWeb.Resolvers.TransactionsResolver do
  alias Homework.Transactions
  alias Homework.Repo
  import Absinthe.Resolution.Helpers

  @doc """
  Get a list of transcations
  """
  def transactions(_root, args, _info) do
    Absinthe.Relay.Connection.from_query(
      Transactions.transactions_query(args),
      &Repo.all/1,
      args
    )
  end

  @doc """
  Get a transaction
  """
  def get_transaction(_, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Transactions, Transactions.Transaction, id)
    |> on_load(fn loader ->
      {:ok, Dataloader.get(loader, Transactions, Transactions.Transaction, id)}
    end)
  end

  @doc """
  Create a new transaction
  """
  def create_transaction(_root, args, _info) do
    case Transactions.create_transaction(args) do
      {:ok, transaction} ->
        {:ok, transaction}

      error ->
        {:error, "could not create transaction: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a transaction for an id with args specified.
  """
  def update_transaction(_root, %{id: id} = args, _info) do
    transaction = Transactions.get_transaction!(id)

    case Transactions.update_transaction(transaction, args) do
      {:ok, transaction} ->
        {:ok, transaction}

      error ->
        {:error, "could not update transaction: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a transaction for an id
  """
  def delete_transaction(_root, %{id: id}, _info) do
    transaction = Transactions.get_transaction!(id)

    case Transactions.delete_transaction(transaction) do
      {:ok, transaction} ->
        {:ok, transaction}

      error ->
        {:error, "could not update transaction: #{inspect(error)}"}
    end
  end
end
