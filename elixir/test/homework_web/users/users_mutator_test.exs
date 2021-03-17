defmodule HomeworkWeb.Schema.Mutation.UsersTest do
  use HomeworkWeb.ConnCase

  @query """
  mutation{
    createUser(firstName: "abe", lastName: "haile", dob: "07/14/1995"){
      id
      firstName
      lastName
      dob
    }
  }
  """
  test "createUser creates a user" do
    conn = build_conn()

    conn = post(conn, "/api", query: @query)

    assert %{
             "data" => %{
               "createUser" => %{
                 "dob" => "07/14/1995",
                 "firstName" => "abe",
                 "id" => _,
                 "lastName" => "haile"
               }
             }
           } = json_response(conn, 200)
  end

  test "updateUser updates a user" do
    conn = build_conn()
    user = insert(:user)

    query = """
    mutation{
      updateUser(id: "#{user.id}", firstName: "new first", lastName: "new last", dob: "03/16/2021" ) {
        firstName
        lastName
        dob
      }
    }
    """

    conn = post(conn, "/api", query: query)

    assert %{
             "data" => %{
               "updateUser" => %{
                 "dob" => "03/16/2021",
                 "firstName" => "new first",
                 "lastName" => "new last"
               }
             }
           } = json_response(conn, 200)
  end

  test "deleteUser deletes a user" do
    conn = build_conn()
    user = insert(:user)

    mutation = """
    mutation{
      deleteUser(id: "#{user.id}") {
        id
      }
    }
    """

    conn = post(conn, "/api", query: mutation)

    assert %{
             "data" => %{
               "deleteUser" => %{
                 "id" => _
               }
             }
           } = json_response(conn, 200)

    assert Homework.Repo.all(Homework.Users.User) == []
  end
end
