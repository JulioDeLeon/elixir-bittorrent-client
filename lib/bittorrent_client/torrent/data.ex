defmodule BittorrentClient.Torrent.Data do
  @moduledoc """
  Torrent data defines struct which will represent relavent torrent worker information to be passed between processes
  Fields are:
  * `id` - 20-byte SHA1 hash string which uniquely identifies the process.
  * `pid` - Erlang assigned PID for reference (MAY NOT BE NEEDED).
  * `status` - the status of the torrent process, :initial | :started | :finished | :seeding | ???.
  * `info_hash` - 20-byte SHA1 hash to be used in handshake and fact checking steps.
  * `peer_id` -
  """
  @type torrent_state ::
          :initial | :connected | :started | :completed | :paused | :error
  @derive {Poison.Encoder,
           except: [
             :pid,
             :tracker_info,
             :info_hash,
             :conected_peers,
             :peer_timer
           ]}
  defstruct [
    :id,
    :pid,
    :file,
    :status,
    :info_hash,
    :peer_id,
    :port,
    :uploaded,
    :downloaded,
    :left,
    :compact,
    :no_peer_id,
    :ip,
    :numwant,
    :numallowed,
    :key,
    :trackerid,
    :tracker_info,
    :pieces,
    :num_pieces,
    :next_piece_index,
    :connected_peers,
    :peer_timer
  ]

  @type t :: %__MODULE__{
          id: integer,
          file: String.t(),
          status: String.t(),
          info_hash: String.t(),
          peer_id: String.t(),
          port: integer,
          uploaded: integer,
          downloaded: integer,
          left: integer,
          compact: boolean,
          no_peer_id: boolean,
          ip: String.t(),
          numwant: integer,
          numallowed: integer,
          key: String.t(),
          trackerid: String.t(),
          # tracker_info:
          next_piece_index: integer,
          pieces: map(),
          num_pieces: integer,
          connected_peers: map()
        }

  def get_peers(data) do
    data |> Map.get(:tracker_info) |> Map.get(:peers)
  end

  def get_connected_peers(data) do
    data |> Map.get(:connected_peers)
  end

  def remove_bad_ip_from_peers(data, ip, port) do
    tinfo = Map.get(data, :tracker_info)

    new_peers =
      tinfo
      |> Map.get(:peers)
      |> Enum.filter(fn peer -> peer != {ip, port} end)

    new_tinfo =
      tinfo
      |> Map.put(:peers, new_peers)

    data |> Map.put(:tracker_info, new_tinfo)
  end
end
