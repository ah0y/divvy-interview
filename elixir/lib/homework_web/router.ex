defmodule HomeworkWeb.Router do
  use HomeworkWeb, :router
  @dialyzer {:no_return, {:__checks__, 0}}

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:api)

    forward("/api", Absinthe.Plug, schema: HomeworkWeb.Schema)

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: HomeworkWeb.Schema,
      interface: :simple,
      context: %{pubsub: HomeworkWeb.Endpoint}
    )
  end
end
