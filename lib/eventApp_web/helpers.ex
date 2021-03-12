defmodule EventAppWeb.Helpers do
  def logged_in?(conn) do
    conn.assigns[:current_user] != nil
  end

  def current_user_id?(conn, user_id) do
    user = conn.assigns[:current_user]
    user && user.id == user_id
  end

  def current_user_id(conn) do
    user = conn.assigns[:current_user]
    user.id
  end

  def current_event_id(conn) do
    IO.puts("in helper: #{Kernel.inspect(conn.assigns[:event])}")
    event = conn.assigns[:event]
    event.id
  end

  def translate_attending(invite) do
    case invite.attending do
      1  -> "✔️"
      -1 -> "❌"
      _  -> "❓"
    end
  end

  def is_user_invited(conn, event) do
    user = conn.assigns[:current_user]
    actual_inv = Enum.find(event.invites, fn x -> x.user_id == user.id end)
    actual_inv != nil
  end

  def get_invite(conn, event) do
    user = conn.assigns[:current_user]
    actual_inv = Enum.find(event.invites, fn x -> x.user_id == user.id end)
    actual_inv
  end

  def can_delete_comment(conn, event, comment) do
    user = conn.assigns[:current_user]
    user.id == event.user_id || user.id == comment.user_id
    # if user.id == event.user_id do
    #   true
    # else
    #   if user.id == comment.user_id
    # end
  end

  def count_uncertain(conn, event) do
    Enum.reduce(event.invites, 0, fn x,acc ->
      if x.attending == 0 do
        1 + acc
      else
        acc
      end
    end)
  end

  def count_coming(conn, event) do
    Enum.reduce(event.invites, 0, fn x,acc ->
      if x.attending == 1 do
        1 + acc
      else
        acc
      end
    end)
  end

  def count_not_coming(conn, event) do
    Enum.reduce(event.invites, 0, fn x,acc ->
      if x.attending == -1 do
        1 + acc
      else
        acc
      end
    end)
  end
end
