defmodule HomeworkWeb.Schema.Query.MerchantsTest do
  use HomeworkWeb.ConnCase

  @query """
  query{
    merchants(first: 10) {
      edges {
        node {
          id
          name
          description
        }
      }
    }
  }
  """
  test "merchants query returns merchants" do
    insert(:merchant, name: "abes pizza")
    conn = build_conn()
    conn = get(conn, "/api", query: @query)

    assert %{
             "data" => %{
               "merchants" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "description" => "description",
                       "id" => _,
                       "name" => "abes pizza"
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)
  end

  @query """
  query{
    merchants(first: 10, filter: {name: "abe"}) {
      edges {
        node {
          id
          name
          description
        }
      }
    }
  }
  """
  test "can filter merchants by name" do
    insert(:merchant, name: "abes pizza")
    insert(:merchant, name: "rival")

    conn = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{
               "merchants" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "description" => "description",
                       "id" => _,
                       "name" => "abes pizza"
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)
  end

  @query """
  query{
    merchants(first: 10, filter: {blah: "merchant"}) {
      edges {
        node {
          id
          name
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
             "Argument \"filter\" has invalid value {blah: \"merchant\"}.\nIn field \"blah\": Unknown field."
  end
end
