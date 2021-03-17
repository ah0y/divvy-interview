defmodule Homework.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory(attrs) do
        %Homework.Users.User{
          dob: "07/14/1995",
          first_name: sequence(Map.get(attrs, :first_name, "abe")),
          last_name: sequence(Map.get(attrs, :last_name, "haile"))
        }
      end
    end
  end
end
