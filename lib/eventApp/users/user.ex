defmodule EventApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventApp.Repo
  alias EventApp.Users.User

  schema "users" do
    field :email, :string
    field :name, :string
    has_many :events, EventApp.Events.Event


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end

  # below get_user!
  def get_user(id), do: Repo.get(EventApp.Users.User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
