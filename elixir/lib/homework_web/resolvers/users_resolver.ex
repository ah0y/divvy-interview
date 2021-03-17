defmodule HomeworkWeb.Resolvers.UsersResolver do
  alias Homework.Users
  alias Homework.Repo
  import Absinthe.Resolution.Helpers

  @doc """
  Get a list of users
  """
  def users(_root, args, _info) do
    Absinthe.Relay.Connection.from_query(
      Users.users_query(args),
      &Repo.all/1,
      args
    )
  end

  @doc """
  Get a user
  """
  def get_user(_, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Users, Users.User, id)
    |> on_load(fn loader ->
      {:ok, Dataloader.get(loader, Users, User.User, id)}
    end)
  end

  @doc """
  Creates a user
  """
  def create_user(_root, args, _info) do
    case Users.create_user(args) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not create user: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a user for an id with args specified.
  """
  def update_user(_root, %{id: id} = args, _info) do
    user = Users.get_user(id)

    case Users.update_user(user, args) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not update user: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a user for an id
  """
  def delete_user(_root, %{id: id}, _info) do
    user = Users.get_user(id)

    case Users.delete_user(user) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not update user: #{inspect(error)}"}
    end
  end
end
