defmodule Homework.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    field(:credit_line, :integer)
    field(:name, :string)
    field(:available_credit, :integer)

    has_many(:users, Homework.Users.User)
    has_many(:transactions, through: [:users, :transactions])

    timestamps()
  end

  @doc false
  def create_changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :credit_line, :available_credit])
    |> validate_required([:name, :credit_line, :available_credit])
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :credit_line, :available_credit])
    |> validate_required([:name, :credit_line, :available_credit])
    |> maybe_update_available_credit
  end

  def maybe_update_available_credit(changeset) do
    credit_line_change = get_change(changeset, :credit_line)
    available_credit = get_field(changeset, :available_credit)

    # credit line change of 10 -> 5, do 5 (new line) - 10 to get -5 to avail.
    # credit line change of 5 -> 10, do 10 (new line) - 5 to get +5 to avail.
    if credit_line_change do
      put_change(changeset, :available_credit, credit_line_change - available_credit)
    else
      changeset
    end
  end
end
