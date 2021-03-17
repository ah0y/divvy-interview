defmodule Homework.TransactionFactory do
  defmacro __using__(_opts) do
    quote do
      def transaction_factory do
        %Homework.Transactions.Transaction{
          amount: 150,
          credit: true,
          debit: true,
          description: "some description"
        }
      end
    end
  end
end
