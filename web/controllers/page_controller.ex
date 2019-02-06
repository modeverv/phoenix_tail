defmodule PhoenixTail.PageController do
  use PhoenixTail.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
