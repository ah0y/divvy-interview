defmodule HomeworkWeb.Schema do
  @moduledoc """
  Defines the graphql schema for this project.
  """
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias HomeworkWeb.Resolvers.{
    CompaniesResolver,
    MerchantsResolver,
    TransactionsResolver,
    UsersResolver
  }

  alias Homework.Transactions.Transaction
  alias Homework.Companies.Company
  alias Homework.Users.User
  alias Homework.Merchants.Merchant
  alias Homework.Transactions
  alias Homework.Companies
  alias Homework.Users
  alias Homework.Merchants
  alias Homework.Repo

  import_types(HomeworkWeb.Schemas.Types)

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  # using dataloader to fix n+1 problems
  def dataloader() do
    Dataloader.new()
    |> Dataloader.add_source(Companies, Companies.data())
    |> Dataloader.add_source(Transactions, Transactions.data())
    |> Dataloader.add_source(Merchants, Merchants.data())
    |> Dataloader.add_source(Users, Users.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  node interface do
    resolve_type(fn
      %Transaction{}, _ ->
        :transaction

      %Company{}, _ ->
        :company

      %Merchant{}, _ ->
        :merchant

      %User{}, _ ->
        :user

      _, _ ->
        nil
    end)
  end

  query do
    node field do
      resolve(fn
        %{type: :transaction, id: local_id}, _ ->
          {:ok, Repo.get(Transaction, local_id)}

        %{type: :company, id: local_id}, _ ->
          {:ok, Repo.get(Transaction, local_id)}

        %{type: :user, id: local_id}, _ ->
          {:ok, Repo.get(Transaction, local_id)}

        %{type: :merchant, id: local_id}, _ ->
          {:ok, Repo.get(Transaction, local_id)}

        _, _ ->
          {:error, "Unknown node"}
      end)
    end

    @desc "Get all Transactions"
    connection field(:transactions, node_type: :transaction) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&TransactionsResolver.transactions/3)
    end

    @desc "Get a Transaction"
    field(:transaction, :transaction) do
      arg(:id, non_null(:id))
      resolve(&TransactionsResolver.get_transaction/3)
    end

    @desc "Get all Users"
    connection field(:users, node_type: :user) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&UsersResolver.users/3)
    end

    @desc "Get a User"
    field(:user, :user) do
      arg(:id, non_null(:id))
      resolve(&UsersResolver.get_user/3)
    end

    @desc "Get all Merchants"
    connection field(:merchants, node_type: :merchant) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&MerchantsResolver.merchants/3)
    end

    @desc "Get a Merchant"
    field(:merchant, :merchant) do
      arg(:id, non_null(:id))
      resolve(&MerchantsResolver.get_merchant/3)
    end

    @desc "Get all Companies"
    connection field(:companies, node_type: :company) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&CompaniesResolver.companies/3)
    end

    @desc "Get a Company"
    field(:company, :company) do
      arg(:id, non_null(:id))
      resolve(&CompaniesResolver.get_company/3)
    end
  end

  mutation do
    import_fields(:transaction_mutations)
    import_fields(:user_mutations)
    import_fields(:merchant_mutations)
    import_fields(:company_mutations)
  end
end
