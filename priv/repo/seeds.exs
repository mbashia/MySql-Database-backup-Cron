# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todo.Repo.insert!(%Todo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

1..10000
|> Enum.map(fn x ->
  %{
    name: "name#{x}",
    description: "description#{x}"
  }
  |> Todo.Tasks.create_task()

  IO.inspect("inserted #{x}")
end)
