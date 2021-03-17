defmodule Homework.TransactionsTest do
  use Homework.DataCase

  alias Homework.Transactions

  describe "transactions" do
    alias Homework.Transactions.Transaction

    def transaction_fixture() do
      merchant = insert(:merchant)

      user = insert(:user)

      _company = insert(:company, users: [user])

      {:ok, transaction} =
        params_for(:transaction, user: user, merchant: merchant)
        |> Transactions.create_transaction()

      transaction
    end

    test "list_transactions/1 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions([]) == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      merchant = insert(:merchant)

      user = insert(:user)

      _company = insert(:company, users: [user])

      params = params_for(:transaction, user: user, merchant: merchant)

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(params)

      assert transaction.amount == 150
      assert transaction.credit == true
      assert transaction.debit == true
      assert transaction.description == "some description"
      assert transaction.merchant_id
      assert transaction.user_id
    end

    # test "create_transaction/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(%{})
    # end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Transactions.update_transaction(transaction, %{
                 credit: false,
                 debit: false,
                 description: "some updated description"
               })

      assert transaction.amount == 150
      assert transaction.credit == false
      assert transaction.debit == false
      assert transaction.description == "some updated description"
      assert transaction.merchant_id
      assert transaction.user_id
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, %{debit: "debit"})

      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
