defmodule BrowserGaymeWeb.PageController do
  use BrowserGaymeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
