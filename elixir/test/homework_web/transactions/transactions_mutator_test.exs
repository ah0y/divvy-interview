defmodule HomeworkWeb.Schema.Mutation.TransactionsTest do
  use HomeworkWeb.ConnCase

  test "createTransaction creates a transaction" do
    conn = build_conn()
    user = insert(:user, first_name: "abe", last_name: "haile")
    _company = insert(:company, name: "abes startup", users: [user])
    merchant = insert(:merchant)

    query = """
    mutation{
      createTransaction(userId: "#{user.id}", amount: 1000.50, merchantId: "#{merchant.id}", credit: false, debit: false, description: "parking") {
        id
        amount
        credit
        debit
        description
        userId
      }
    }
    """

    conn = post(conn, "/api", query: query)

    assert %{
             "data" => %{
               "createTransaction" => %{
                 "amount" => "1000.5",
                 "credit" => false,
                 "debit" => false,
                 "description" => "parking",
                 "id" => _,
                 "userId" => user_id
               }
             }
           } = json_response(conn, 200)

    assert user_id == user.id
  end

  test "updateUser updates a user" do
    conn = build_conn()
    user = insert(:user, first_name: "abe", last_name: "haile")
    _company = insert(:company, name: "abes startup", users: [user])
    merchant = insert(:merchant)
    transaction = insert(:transaction, user: user, amount: 100_050, merchant: merchant)

    query = """
    mutation{
      updateTransaction(id: "#{transaction.id}", amount: 0, credit: false, debit: false, description: "fixed transaction") {
        amount
        debit
        credit
        description
      }
    }
    """

    conn = post(conn, "/api", query: query)

    assert %{
             "data" => %{
               "updateTransaction" => %{
                 "amount" => "0.0",
                 "credit" => false,
                 "debit" => false,
                 "description" => "fixed transaction"
               }
             }
           } = json_response(conn, 200)
  end

  test "deleteTransaction deletes a transaction" do
    conn = build_conn()
    user = insert(:user, first_name: "abe", last_name: "haile")
    _company = insert(:company, name: "abes startup", users: [user])
    merchant = insert(:merchant)
    transaction = insert(:transaction, user: user, amount: 100_050, merchant: merchant)

    mutation = """
    mutation{
      deleteTransaction(id: "#{transaction.id}") {
        id
      }
    }
    """

    conn = post(conn, "/api", query: mutation)

    assert %{
             "data" => %{
               "deleteTransaction" => %{
                 "id" => _
               }
             }
           } = json_response(conn, 200)

    assert Homework.Repo.all(Homework.Transactions.Transaction) == []
  end
end
