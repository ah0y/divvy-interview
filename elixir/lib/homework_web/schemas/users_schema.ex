defmodule HomeworkWeb.Schemas.UsersSchema do
  @moduledoc """
  Defines the graphql schema for user.
  """
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Homework.Transactions
  alias Homework.Companies
  alias HomeworkWeb.Resolvers.UsersResolver

  import Absinthe.Resolution.Helpers

  connection(node_type: :user)

  node object(:user) do
    field(:dob, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:inserted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)

    field(:copmany, :company, resolve: dataloader(Companies))

    field :transactions, list_of(:transaction) do
      arg(:filter, :filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(dataloader(Transactions, :transactions))
    end
  end

  object :user_mutations do
    @desc "Create a new user"
    field :create_user, :user do
      arg(:dob, non_null(:string))
      arg(:first_name, non_null(:string))
      arg(:last_name, non_null(:string))

      resolve(&UsersResolver.create_user/3)
    end

    @desc "Update a new user"
    field :update_user, :user do
      arg(:id, non_null(:id))
      arg(:dob, non_null(:string))
      arg(:first_name, non_null(:string))
      arg(:last_name, non_null(:string))

      resolve(&UsersResolver.update_user/3)
    end

    @desc "delete an existing user"
    field :delete_user, :user do
      arg(:id, non_null(:id))

      resolve(&UsersResolver.delete_user/3)
    end
  end
end
