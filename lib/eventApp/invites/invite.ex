defmodule EventApp.Invites.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invites" do
    field :attending, :integer
    belongs_to :event, EventApp.Events.Event
    belongs_to :user, EventApp.Users.User
    # field :event_id, :id
    # field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:attending, :event_id, :user_id])
    |> validate_required([:attending, :event_id, :user_id])
  end
end
