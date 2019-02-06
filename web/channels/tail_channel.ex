defmodule PhoenixTail.TailChannel do
  use Phoenix.Channel

  def join("tails:sample",auth_msg, socket) do
    {:ok, socket}
  end

  def join("tails:" <> _private_room_id, _auth_msg, socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
