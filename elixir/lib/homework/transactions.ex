defmodule Homework.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Transactions.Transaction
  alias Homework.Users
  alias Homework.Companies

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions([])
      [%Transaction{}, ...]

  """
  def list_transactions(args) do
    args
    |> transactions_query
    |> Repo.all()
  end

  def transactions_query(args) do
    Enum.reduce(args, Transaction, fn
      {:order, order}, query ->
        query |> order_by({^order, :inserted_at})

      {:filter, filter}, query ->
        query |> filter_with(filter)

      _, query ->
        query
    end)
  end

  defp filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:min, min}, query ->
        from(q in query, where: q.amount >= ^min)

      {:max, max}, query ->
        from(q in query, where: q.amount <= ^max)

      {:after, date}, query ->
        from(q in query, where: q.added_on >= ^date)

      {:before, date}, query ->
        from(q in query, where: q.added_on <= ^date)
    end)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    changeset =
      %Transaction{}
      |> Transaction.changeset(attrs)

    company =
      Users.get_user(attrs.user_id)
      |> Repo.preload(:company)
      |> Map.get(:company)

    case maybe_create_transaction(attrs, company, changeset) do
      {:ok, transaction_transaction_result} -> transaction_transaction_result
      e -> e
    end
  end

  defp maybe_create_transaction(attrs, company, changeset) do
    Repo.transaction(fn ->
      {:ok, _updated_company} =
        Companies.update_company(company, %{
          available_credit: company.available_credit - attrs.amount
        })

      {:ok, _transaction} = Repo.insert(changeset)
    end)
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(Transaction, args) do
    transactions_query(args)
  end

  def query(queryable, _) do
    queryable
  end
end
