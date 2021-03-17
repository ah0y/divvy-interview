defmodule HomeworkWeb.Schema.Query.UsersTest do
  use HomeworkWeb.ConnCase

  @query """
  query{
    users(first: 10) {
      edges {
        node {
          id
          firstName
          lastName
          dob
        }
      }
    }
  }
  """
  test "users query returns users" do
    me = insert(:user, first_name: "abe", last_name: "haile")
    conn = build_conn()
    conn = get(conn, "/api", query: @query)

    assert %{
             "data" => %{
               "users" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "dob" => "07/14/1995",
                       "firstName" => first,
                       "id" => _,
                       "lastName" => last
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)

    assert me.first_name == first
    assert me.last_name == last
  end

  @query """
  query{
    users(first: 10, filter: {name: "abe"}) {
      edges {
        node {
          id
          firstName
          lastName
          dob
        }
      }
    }
  }
  """
  test "can filter users by name" do
    me = insert(:user, first_name: "abe", last_name: "haile")
    insert(:user, first_name: "john", last_name: "smith")

    conn = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{
               "users" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "dob" => "07/14/1995",
                       "firstName" => first,
                       "id" => _,
                       "lastName" => last
                     }
                   }
                 ]
               }
             }
           } = json_response(conn, 200)

    assert me.first_name =~ first
    assert me.last_name =~ last
  end

  @query """
  query{
    users(first: 10, filter: {blah: "abe"}) {
      edges {
        node {
          id
          firstName
          lastName
          dob
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
             "Argument \"filter\" has invalid value {blah: \"abe\"}.\nIn field \"blah\": Unknown field."
  end
end
