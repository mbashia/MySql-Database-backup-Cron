defmodule Todo.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:task) do
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
