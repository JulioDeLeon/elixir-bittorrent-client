defmodule BittorrentClient.Web do
  @moduledoc """
  Web module defines the RESTful api to interact with BittorrentClient
  """
  use Plug.Router
  alias Plug.Conn, as: Conn

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass: ["text/*"],
                     json_decoder: Poison
  plug :match
  plug :dispatch

  @api_root "/api/v1"

  get "/ping" do
    send_resp(conn, 200, "pong")
  end

  get "#{@api_root}/:id/status" when byte_size(id) > 3 do
    IO.puts Enum.join(["Received the following ID: ", id])
    send_resp(conn, 200, Enum.join(["Returning: ", id, "\n"]))
  end

  post "#{@api_root}/add/file" do
    conn = Conn.fetch_query_params(conn)
    filename = conn.params["filename"]
    IO.puts "Received the following filename: #{filename}"
	{status, data} = BittorrentClient.Server.add_new_torrent("GenericName", filename)
    case status do
      :ok -> send_resp(conn, 200, data)
      :error -> send_resp(conn, 400, data)
      _ -> send_resp(conn, 500, "Don't know what happened")
    end
  end

  delete "#{@api_root}/remove/id" do
    conn = Conn.fetch_query_params(conn)
    id = conn.params["id"]
    IO.puts "Received the following filename: #{id}"
	{status, data} = BittorrentClient.Server.delete_torrent_by_id("GenericName", id)
    case status do
      :ok -> send_resp(conn, 200, data)
      :error -> send_resp(conn, 400, data)
      _ -> send_resp(conn, 500, "Don't know what happened")
    end
  end

  get "#{@api_root}/all" do
  	{_, data} = BittorrentClient.Server.list_current_torrents("GenericName")
    put_resp_content_type(conn, "application/json")
    send_resp(conn, 200, Poison.encode!(data))
  end

  delete "#{@api_root}/remove/all" do
	{_, _} = BittorrentClient.Server.delete_all_torrents("GenericName")
    send_resp(conn, 200, "All torrents deleted")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

end
