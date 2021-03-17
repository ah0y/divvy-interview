defmodule HomeworkWeb.Schema.Mutation.CompaniesTest do
  use HomeworkWeb.ConnCase

  @query """
    mutation{
      createCompany(name: "abes startup", creditLine: 1005.00, availableCredit: 1005.00){
        id
        name
        availableCredit
        creditLine
      }
    }
  """
  test "createCompany creates a company" do
    conn = build_conn()

    conn = post(conn, "/api", query: @query)

    assert %{
             "data" => %{
               "createCompany" => %{
                 "availableCredit" => "1005.0",
                 "creditLine" => "1005.0",
                 "id" => _,
                 "name" => "abes startup"
               }
             }
           } = json_response(conn, 200)
  end

  test "updateCompany updates a company" do
    conn = build_conn()
    company = insert(:company)

    query = """
    mutation{
      updateCompany(id: #{company.id}, name: "rebranded company" ) {
        name
      }
    }
    """

    conn = post(conn, "/api", query: query)

    assert %{
             "data" => %{
               "updateCompany" => %{"name" => "rebranded company"}
             }
           } = json_response(conn, 200)
  end

  test "deleteCompany deletes a company" do
    conn = build_conn()
    company = insert(:company)

    mutation = """
    mutation{
      deleteCompany(id: "#{company.id}") {
        id
      }
    }
    """

    conn = post(conn, "/api", query: mutation)

    assert %{
             "data" => %{
               "deleteCompany" => %{
                 "id" => _
               }
             }
           } = json_response(conn, 200)

    assert Homework.Repo.all(Homework.Companies.Company) == []
  end
end
