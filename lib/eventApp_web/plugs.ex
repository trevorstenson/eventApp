defmodule EventApp.Plugs.FetchSession do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    user = EventApp.Users.User.get_user(get_session(conn, :user_id) || -1)
    IO.puts(Kernel.inspect(user))
    if user do
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end
end
