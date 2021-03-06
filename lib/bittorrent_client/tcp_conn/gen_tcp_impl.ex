defmodule BittorrentClient.TCPConn.GenTCPImpl do
  @moduledoc """
  :gen_tcp implementation of TCPConn behaviour
  """
  @behaviour BittorrentClient.TCPConn
  alias BittorrentClient.TCPConn, as: TCPConn

  def connect(ip, port, opts \\ []) do
    case :gen_tcp.connect(ip, port, opts) do
      {:ok, socket} ->
        {:ok,
         %TCPConn{
           socket: socket,
           parent_pid: self()
         }}

      error ->
        {:error,
         "could not connect to #{inspect(ip)}:#{inspect(port)} - #{
           inspect(error)
         }"}
    end
  end

  def connect(ip, port, opts, timeout) do
    case :gen_tcp.connect(ip, port, opts, timeout) do
      {:ok, socket} ->
        {:ok,
         %TCPConn{
           socket: socket,
           parent_pid: self()
         }}

      error ->
        {:error,
         "could not connect to #{inspect(ip)}:#{inspect(port)} - #{
           inspect(error)
         }"}
    end
  end

  def accept(tcp_conn) do
    {status, ret} = :gen_tcp.accept(tcp_conn.socket)

    case status do
      :ok ->
        {:ok, %TCPConn{tcp_conn | socket: ret}}

      _ ->
        {status, ret}
    end
  end

  def accept(tcp_conn, timeout) do
    {status, ret} = :gen_tcp.accept(tcp_conn.socket, timeout)

    case status do
      :ok ->
        {:ok, %TCPConn{tcp_conn | socket: ret}}

      _ ->
        {status, ret}
    end
  end

  def controlling_process(tcp_conn, pid) do
    ret = :gen_tcp.controlling_process(tcp_conn.socket, pid)

    case ret do
      :ok ->
        {:ok, %TCPConn{tcp_conn | parent_pid: pid}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def listen(port, opts) do
    {status, ret} = :gen_tcp.listen(port, opts)

    case status do
      :ok ->
        {:ok, %TCPConn{socket: ret, parent_pid: self()}}

      _ ->
        {:error, ret}
    end
  end

  def recv(tcp_conn, len) do
    :gen_tcp.recv(tcp_conn.socket, len)
  end

  def recv(tcp_conn, len, timeout) do
    :gen_tcp.recv(tcp_conn.socket, len, timeout)
  end

  def send(tcp_conn, packet) do
    case :gen_tcp.send(tcp_conn.socket, packet) do
      :ok ->
        :ok

      {:error, msg} ->
        {:error,
         "could not send message to #{inspect(tcp_conn)} : #{inspect(msg)}"}
    end
  end

  def close(tcp_conn) do
    :gen_tcp.close(tcp_conn.socket)
  end

  def shutdown(tcp_conn, how) do
    :gen_tcp.shutdown(tcp_conn.socket, how)
  end
end
