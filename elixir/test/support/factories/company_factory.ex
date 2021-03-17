defmodule Homework.CompanyFactory do
  defmacro __using__(_opts) do
    quote do
      def company_factory do
        %Homework.Companies.Company{
          name: sequence("company"),
          credit_line: 100_050,
          available_credit: 100_050
        }
      end
    end
  end
end
