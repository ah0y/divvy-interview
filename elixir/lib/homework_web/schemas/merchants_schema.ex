defmodule HomeworkWeb.Schemas.MerchantsSchema do
  @moduledoc """
  Defines the graphql schema for merchants.
  """
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Homework.Transactions
  alias HomeworkWeb.Resolvers.MerchantsResolver

  import Absinthe.Resolution.Helpers

  connection(node_type: :merchant)

  node object(:merchant) do
    field(:name, :string)
    field(:description, :string)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field :transactions, list_of(:transaction) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(dataloader(Transactions, :transactions))
    end
  end

  object :merchant_mutations do
    @desc "Create a new merchant"
    field :create_merchant, :merchant do
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))

      resolve(&MerchantsResolver.create_merchant/3)
    end

    @desc "Update a new merchant"
    field :update_merchant, :merchant do
      arg(:id, non_null(:id))
      arg(:name, non_null(:string))
      arg(:description, non_null(:string))

      resolve(&MerchantsResolver.update_merchant/3)
    end

    @desc "delete an existing merchant"
    field :delete_merchant, :merchant do
      arg(:id, non_null(:id))

      resolve(&MerchantsResolver.delete_merchant/3)
    end
  end
end
