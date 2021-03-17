defmodule HomeworkWeb.Schemas.Types do
  @moduledoc """
  Defines the types for the Schema to use.
  """
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  # I ended up taking out absinthes custom types and ripping out exactly what I needed
  # since I wanted to do something custom with decimal and import_types wasn't allowing
  # me to use only/except
  import_types(HomeworkWeb.Schemas.CompaniesSchema)
  import_types(HomeworkWeb.Schemas.MerchantsSchema)
  import_types(HomeworkWeb.Schemas.TransactionsSchema)
  import_types(HomeworkWeb.Schemas.UsersSchema)

  @desc "Filtering options"
  input_object :filter do
    @desc "Matching a name"
    field(:name, :string)

    @desc "Max dollar amount"
    field(:min, :decimal)

    @desc "Min dollar amount"
    field(:max, :decimal)

    @desc "Before a certain date"
    field(:before, :date)

    @desc "After a certain date"
    field(:after, :date)
  end

  scalar :decimal do
    parse(fn float ->
      decimal = Decimal.from_float(float.value / 1)

      integer =
        decimal
        |> Decimal.mult(100)
        |> Decimal.to_integer()

      {:ok, integer}
    end)

    serialize(fn integer ->
      float = integer / 100

      decimal = Decimal.from_float(float)
      Decimal.to_string(decimal, :normal)
    end)
  end

  # taken directly out of absinthe since I couldn't exclude just decimal with Absinthe.Custoom
  scalar :naive_datetime, name: "NaiveDateTime" do
    description("""
    The `Naive DateTime` scalar type represents a naive date and time without
    timezone. The DateTime appears in a JSON response as an ISO8601 formatted
    string.
    """)

    serialize(&NaiveDateTime.to_iso8601/1)
    parse(&parse_naive_datetime/1)
  end

  @spec parse_naive_datetime(Absinthe.Blueprint.Input.String.t()) ::
          {:ok, NaiveDateTime.t()} | :error
  @spec parse_naive_datetime(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_naive_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case NaiveDateTime.from_iso8601(value) do
      {:ok, naive_datetime} -> {:ok, naive_datetime}
      _error -> :error
    end
  end

  defp parse_naive_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_naive_datetime(_) do
    :error
  end

  # taken directly out of absinthe since I couldn't import everything _except_ decimal

  scalar :date do
    description("""
    The `Date` scalar type represents a date. The Date appears in a JSON
    response as an ISO8601 formatted string, without a time component.
    """)

    serialize(&Date.to_iso8601/1)
    parse(&parse_date/1)
  end

  @spec parse_date(Absinthe.Blueprint.Input.String.t()) :: {:ok, Date.t()} | :error
  @spec parse_date(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_date(%Absinthe.Blueprint.Input.String{value: value}) do
    case Date.from_iso8601(value) do
      {:ok, date} -> {:ok, date}
      _error -> :error
    end
  end

  defp parse_date(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_date(_) do
    :error
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end
