defmodule EventAppWeb.InviteController do
  use EventAppWeb, :controller

  alias EventApp.Invites
  alias EventApp.Invites.Invite
  alias EventApp.Events
  alias EventApp.Users
  alias EventAppWeb.Plugs
  alias EventApp.Repo

  plug Plugs.Authorization when action not in [:index]
  plug :fetch_invite when action in [:respond_to_invite, :going, :not_going]
  plug :is_invited when action in [:respond_to_invite]

  def index(conn, _params) do
    IO.puts("hitting index invites")
    invites = Invites.list_invites()
    render(conn, "index.html", invites: invites)
  end

  def new(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    inv = %Invite{
      event_id: event.id,
      attending: 0
    }
    changeset = Invites.change_invite(inv)
    render(conn, "new.html", changeset: changeset)
  end


  def going(conn,  %{"invite_id" => id}) do
    IO.puts("YOOOO")

    invite = conn.assigns[:invite]
    |> Invites.load_event
    IO.puts("going, #{Kernel.inspect(invite)}")
    invite = Ecto.Changeset.change(invite, attending: 1)
    IO.puts("after update: #{Kernel.inspect(invite)}")
    invite = Repo.update!(invite)
    # render(conn, "show.html", invite: invite)
    redirect(conn, to: Routes.event_path(conn, :show, Events.get_event!(invite.event_id)))
  end


  def not_going(conn,  %{"invite_id" => id}) do
    invite = conn.assigns[:invite]
    |> Invites.load_event
    IO.puts("going, #{Kernel.inspect(invite)}")
    invite = Ecto.Changeset.change(invite, attending: -1)
    IO.puts("after update: #{Kernel.inspect(invite)}")
    invite = Repo.update!(invite)
    redirect(conn, to: Routes.event_path(conn, :show, Events.get_event!(invite.event_id)))
  end

  def create(conn, %{"invite" => invite_params}) do
    IO.puts("incoming params: #{Kernel.inspect(invite_params)}")
    # this is where we need to match up the email to the user
    actual_user = Users.get_user_by_email(invite_params["email"])
    IO.puts("actual user: #{Kernel.inspect(actual_user)}")
    invite_params = invite_params
    |> Map.put("user_id", actual_user.id)
    |> Map.put("attending", 0)
    IO.puts("AFTER params: #{Kernel.inspect(invite_params)}")
    case Invites.create_invite(invite_params) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "Invite created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, Events.get_event!(invite_params["event_id"])))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.html", invite: invite)
  end

  def edit(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    changeset = Invites.change_invite(invite)
    render(conn, "edit.html", invite: invite, changeset: changeset)
  end

  def update(conn, %{"id" => id, "invite" => invite_params}) do
    IO.puts("in HJGASCBKJSAN KJSA")
    invite = Invites.get_invite!(id)

    case Invites.update_invite(invite, invite_params) do
      {:ok, invite} ->
        conn
        |> put_flash(:info, "Invite updated successfully.")
        |> redirect(to: Routes.invite_path(conn, :show, invite))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", invite: invite, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    {:ok, _invite} = Invites.delete_invite(invite)

    conn
    |> put_flash(:info, "Invite deleted successfully.")
    |> redirect(to: Routes.invite_path(conn, :index))
  end

  def fetch_invite(conn, _args) do
    id = conn.params["invite_id"]
    IO.inspect("id: #{id}")
    inv = Invites.get_invite!(id)
    assign(conn, :invite, inv)
  end

  def is_invited(conn, _args) do
    # IO.puts("KILL ME!!")
    # id = conn.params["invite_id"]
    # inv = conn.assigns[:invite]
    # IO.puts("wtf: #{Kernel.inspect(inv)}")
    # IO.puts("current user: #{Kernel.inspect(conn.assigns[:current_user])}")
    # if conn.assigns[:current_user] == inv.user_id do
    #   conn
    # else
    #   conn
    #   |> put_flash(:error, "You are not allowed to respond to this invite.")
    #   |> redirect(to: Routes.page_path(conn, :index))
    #   |> halt
    # end
    conn
  end
end
