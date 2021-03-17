defmodule HomeworkWeb.Schema.Query.CompaniesTest do
  use HomeworkWeb.ConnCase

  @query """
  query{
    companies(first:10) {
      edges {
        node {
          id
          name
          availableCredit
          creditLine
        }
      }
    }
  }
  """
  test "companies query returns companies" do
    insert(:company, name: "abes startup")
    conn = build_conn()
    conn = get(conn, "/api", query: @query)

    assert %{
             "data" => %{
               "companies" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "availableCredit" => "1000.5",
                       "creditLine" => "1000.5",
                       "id" => _,
                       "name" => "abes startup"
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)
  end

  @query """
  query{
    companies(first:10, filter: {name: "abe"}) {
      edges {
        node {
          id
          name
          availableCredit
          creditLine
        }
      }
    }
  }
  """
  test "can filter companies by name" do
    insert(:company, name: "abes startup")
    insert(:company, name: "rival")

    conn = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{
               "companies" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "availableCredit" => "1000.5",
                       "creditLine" => "1000.5",
                       "id" => _,
                       "name" => "abes startup"
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)
  end

  @query """
  query{
    companies(first: 10, filter: {blah: "asdad"}) {
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
             "Argument \"filter\" has invalid value {blah: \"asdad\"}.\nIn field \"blah\": Unknown field."
  end
end
