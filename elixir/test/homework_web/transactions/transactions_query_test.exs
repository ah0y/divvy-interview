defmodule HomeworkWeb.Schema.Query.TransactionssTest do
  use HomeworkWeb.ConnCase

  @query """
  query{
    transactions(first: 10) {
      edges {
        node {
          id
          amount
          credit
          debit
          userId
        }
      }
    }
  }
  """
  test "transactions query returns transactions" do
    user = insert(:user, first_name: "abe", last_name: "haile")
    _company = insert(:company, name: "abes startup", users: [user])
    insert(:transaction, user: user, amount: 100_050)
    conn = build_conn()
    conn = get(conn, "/api", query: @query)

    assert %{
             "data" => %{
               "transactions" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "amount" => "1000.5",
                       "credit" => true,
                       "debit" => true,
                       "id" => _,
                       "userId" => user_id
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)

    assert user_id == user.id
  end

  @query """
  query{
    transactions(first: 10, filter: {min: 200.00, max: 500.00}) {
      edges {
        node {
          id
          amount
          credit
          debit
          userId
        }
      }
    }
  }
  """
  test "can filter transactions by amount" do
    user = insert(:user, first_name: "abe", last_name: "haile")
    _company = insert(:company, name: "abes startup", users: [user])
    insert(:transaction, user: user, amount: 100_00)
    insert(:transaction, user: user, amount: 400_00)
    insert(:transaction, user: user, amount: 900_00)

    conn = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{
               "transactions" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "amount" => "400.0",
                       "credit" => true,
                       "debit" => true,
                       "id" => _,
                       "userId" => _
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)
  end

  @query """
  query{
    transactions(first: 10, filter: {blah: "money"}) {
      edges {
        node {
          id
        }
      }
    }
  }
  """
  test "returns errors when using a bad filter" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "errors" => [
               %{"message" => message}
             ]
           } = json_response(response, 200)

    assert message ==
             "Argument \"filter\" has invalid value {blah: \"money\"}.\nIn field \"blah\": Unknown field."
  end
end
