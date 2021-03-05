# this was used from the lecture notes (at least the structure of this controller)
defmodule EventAppWeb.SessionController do
  use EventAppWeb, :controller

  def create(conn, %{"email" => email}) do
    user = EventApp.Users.User.get_user_by_email(email)
    IO.puts("creating session...")
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.name}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
