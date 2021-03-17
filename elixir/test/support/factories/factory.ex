defmodule Homework.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Homework.Repo

  use Homework.MerchantFactory
  use Homework.UserFactory
  use Homework.CompanyFactory
  use Homework.TransactionFactory
end
