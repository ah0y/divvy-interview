defmodule HomeworkWeb.Schema.Mutation.MerchantsTest do
  use HomeworkWeb.ConnCase

  @query """
  mutation{
    createMerchant(description: "friendly merchant", name: "abes pizza"){
      id
      description
      name
    }
  }
  """
  test "createMerchant creates a merchant" do
    conn = build_conn()

    conn = post(conn, "/api", query: @query)

    assert %{
             "data" => %{
               "createMerchant" => %{
                 "description" => "friendly merchant",
                 "id" => _,
                 "name" => "abes pizza"
               }
             }
           } = json_response(conn, 200)
  end

  test "updateMerchant updates a merchant" do
    conn = build_conn()
    merchant = insert(:merchant)

    mutation = """
    mutation{
      updateMerchant(id: "#{merchant.id}" , name: "updated name", description: "updated description") {
        name
        description
      }
    }
    """

    conn = post(conn, "/api", query: mutation)

    assert %{
             "data" => %{
               "updateMerchant" => %{
                 "description" => "updated description",
                 "name" => "updated name"
               }
             }
           } = json_response(conn, 200)
  end

  test "deleteMerchant deletes a merchant" do
    conn = build_conn()
    merchant = insert(:merchant)

    mutation = """
    mutation{
      deleteMerchant(id: "#{merchant.id}") {
        id
      }
    }
    """

    conn = post(conn, "/api", query: mutation)

    assert %{
             "data" => %{
               "deleteMerchant" => %{
                 "id" => _
               }
             }
           } = json_response(conn, 200)

    assert Homework.Repo.all(Homework.Merchants.Merchant) == []
  end
end
