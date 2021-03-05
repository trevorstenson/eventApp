defmodule EventAppWeb.Plugs.Authorization do
  use EventAppWeb, :controller

  def init(args), do: args

  def call(conn, _args) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You need to be logged in to perform this action.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt
    end
  end



end
