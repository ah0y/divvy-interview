defmodule Homework.MerchantFactory do
  defmacro __using__(_opts) do
    quote do
      def merchant_factory do
        %Homework.Merchants.Merchant{
          description: "description",
          name: sequence("merchant")
        }
      end
    end
  end
end
