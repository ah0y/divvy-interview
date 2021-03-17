# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Homework.Factory

for _i <- 0..10 do
  merchant = insert(:merchant)

  users = insert_list(5, :user)

  _company = insert(:company, users: users)

  for user <- users do
    insert_list(5, :transaction, merchant: merchant, user: user)
  end
end
