defmodule HTMLParsec.PlugTestSample do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  @image_content ~s|<img src="link1"/>\n<img src="link2"/>|
  @anchor_content ~s|<a href="link1">1</a>\n<a href="link2">2</a>|
  @combined_content ~s"""
  <a href="anchor_link1"><img border="0" src="image_link1.gif" width="100" height="100"></a>
  <a href="anchor_link2">
    <img border="0" src="image_link2.gif" width="100" height="100">
  </a>
  """

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello\nworld!")
  end

  get "/images" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, @image_content)
  end

  get "/anchors" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, @anchor_content)
  end

  get "/combined" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, @combined_content)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
