defmodule BittorrentClientTest do
  use ExUnit.Case
  use Plug.Test
  doctest BittorrentClient

  test "the truth" do
    assert 1 + 1 == 2
  end

  @opts BittorrentClient.Web.Router.init({})
  test "returns Pong" do
    conn = conn(:get, "/ping")
    conn = BittorrentClient.Web.Router.call(conn, @opts)

	  assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong"
  end

  # create test for post and put request
  test "compute info hash" do
    require Logger
    file = "examples/debian2.torrent"
    metadata = file
    |> File.read!()
    |> Bento.torrent!()
    {check, info} = metadata.info
    |> Map.from_struct()
    |> Map.delete(:md5sum)
    |> Map.delete(:private)
    |> Bento.encode()
    if check == :error do
      assert false
    else
      hash = :crypto.hash(:sha, info)
      |> URI.encode()
      expected = "%ea%5d%f1%c9h%ab_%16X%a4%e9%cd.%15%d4%ed%de%ef%ed%1e"
      assert hash == expected
    end
  end
end

# 934994	374.234654	192.168.0.15	130.239.18.159	HTTP	333	GET /announce?compact=0&downloaded=0&event=started&info_hash=%A2L%157%84%DBE4F%B3%C3%16%04m%5C%F6x%E1%DC%A5&left=660602880&no_peer_id=0&numwant=0&peer_id=-ET0001-&port=6969&uploaded=0 HTTP/1.1


# 139	32.479680465	192.168.0.3	130.239.18.159	HTTP	424
# GET /announce?
# info_hash=%ea%5d%f1%c9h%ab_%16X%a4%e9%cd.%15%d4%ed%de%ef%ed%1e
# peer_id=-TR2920-vmsfkar3g5jk&port=51413
# uploaded=0
# downloaded=0
# left=1193803776
# numwant=80
# key=675f12e1
# compact=1
# supportcrypto=1
# event=started HTTP/1.1
