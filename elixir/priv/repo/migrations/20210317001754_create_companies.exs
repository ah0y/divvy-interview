defmodule Homework.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add(:name, :string, null: false)

      # make both of these integers non null on the db with a default of 0, so that in the actual schema we dont have to validate required on them, just cast
      add(:credit_line, :integer, null: false, default: 0)
      add(:available_credit, :integer, null: false, default: 0)

      timestamps()
    end

    alter table("users") do
      add(:company_id, references(:companies))
    end

    # alter table("transactions") do
    #   add(:company_id, references(:companies))
    # end
  end
end
