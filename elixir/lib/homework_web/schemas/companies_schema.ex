defmodule HomeworkWeb.Schemas.CompaniesSchema do
  @moduledoc """
  Defines the graphql schema for companies.
  """
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Homework.Transactions
  alias Homework.Users
  alias HomeworkWeb.Resolvers.CompaniesResolver

  import Absinthe.Resolution.Helpers

  connection(node_type: :company)

  node object(:company) do
    field(:name, :string)

    field :available_credit, :decimal do
      # my original idea. keeping it here to demonstrate I know how to use middleware
      # resolve(dataloader(Transactions, :transactions))

      # middleware(fn res, _ ->
      #   sum = Enum.reduce(res.value, 0, fn x, acc -> (x.amount || 0) + acc end)
      #   %{res | value: res.source.credit_line - sum}
      # end)
    end

    field(:credit_line, :decimal)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field :users, list_of(:user) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(dataloader(Users, :users))
    end

    field :transactions, list_of(:transaction) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(dataloader(Transactions, :transactions))
    end
  end

  object :company_mutations do
    @desc "Create a new company"
    field :create_company, :company do
      arg(:name, non_null(:string))
      arg(:credit_line, non_null(:decimal))
      arg(:available_credit, non_null(:decimal))

      resolve(&CompaniesResolver.create_company/3)
    end

    @desc "Update a new company"
    field :update_company, :company do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))

      resolve(&CompaniesResolver.update_company/3)
    end

    @desc "delete an existing company"
    field :delete_company, :company do
      arg(:id, non_null(:id))

      resolve(&CompaniesResolver.delete_company/3)
    end
  end
end
