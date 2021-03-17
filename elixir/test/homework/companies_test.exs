defmodule Homework.CompaniesTest do
  use Homework.DataCase

  alias Homework.Companies
  alias Homework.Companies.Company

  describe "companies" do
    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        params_for(:company, attrs)
        |> Companies.create_company()

      company
    end

    test "list_companies/1 returns all companies" do
      company = company_fixture()
      assert Companies.list_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(params_for(:company))
      assert company.credit_line == 100_050
      assert company.available_credit == 100_050
      assert company.name =~ "company"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(%{credit_line: "number"})
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()

      assert {:ok, %Company{} = updated_company} =
               Companies.update_company(company, %{
                 name: "some updated name"
               })

      assert updated_company.name == "some updated name"
    end

    test "lowering the credit line lowers available credit by the appropriate amount" do
      company = company_fixture(%{available_credit: 100_000})

      assert {:ok, %Company{} = updated_company} =
               Companies.update_company(company, %{
                 name: "some updated name",
                 credit_line: 456_700
               })

      assert updated_company.credit_line == 456_700

      assert updated_company.available_credit ==
               updated_company.credit_line - company.available_credit

      assert updated_company.name == "some updated name"
    end

    test "raising the credit line increases the available credit by the appropriate amount" do
      company = company_fixture(%{available_credit: 100_000})

      assert {:ok, %Company{} = updated_company} =
               Companies.update_company(company, %{
                 name: "some updated name",
                 credit_line: 456_700
               })

      assert updated_company.credit_line == 456_700

      assert updated_company.available_credit ==
               updated_company.credit_line - company.available_credit

      assert updated_company.name == "some updated name"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Companies.update_company(company, %{credit_line: "number"})

      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end
end
