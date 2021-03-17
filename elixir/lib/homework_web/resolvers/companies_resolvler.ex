defmodule HomeworkWeb.Resolvers.CompaniesResolver do
  alias Homework.Companies
  alias Homework.Repo
  import Absinthe.Resolution.Helpers

  @doc """
  Get a list of companies
  """
  def companies(_root, args, _info) do
    Absinthe.Relay.Connection.from_query(
      Companies.companies_query(args),
      &Repo.all/1,
      args
    )
  end

  @doc """
  Get a company
  """

  def get_company(_, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Companies, Companies.Company, id)
    |> on_load(fn loader ->
      {:ok, Dataloader.get(loader, Companies, Companies.Company, id)}
    end)
  end

  @doc """
  Create a new company
  """
  def create_company(_root, args, _info) do
    case Companies.create_company(args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not create company: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a company for an id with args specified.
  """
  def update_company(_root, %{id: id} = args, _info) do
    company = Companies.get_company!(id)

    case Companies.update_company(company, args) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a company for an id
  """
  def delete_company(_root, %{id: id}, _info) do
    company = Companies.get_company!(id)

    case Companies.delete_company(company) do
      {:ok, company} ->
        {:ok, company}

      error ->
        {:error, "could not update company: #{inspect(error)}"}
    end
  end
end
