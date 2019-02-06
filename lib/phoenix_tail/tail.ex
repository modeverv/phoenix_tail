defmodule PhoenixTail.Tail do
  use GenServer

  # 親プロセスとのリンク処理
  def start_link(file) do
    # 引数で受け取ったターゲットファイルのパスを渡します
    GenServer.start_link(__MODULE__, {file})
  end

  # 初期化処理
  def init({file}) do
    # 受け取ったファイルパスをストリームにして、cast を呼びます
    stream = File.stream!(file)
    GenServer.cast(self, :check)
    {:ok, {stream, nil, 0}}
  end

  def handle_cast(:check, {stream, last_modified, position}) do
    # 変更をチェックして broadcast します
    {last_modified, position} = cast_new_lines(stream, last_modified, position)
    # 1秒スリープ後、処理を再帰します
    :timer.sleep(1000)
    GenServer.cast(self, :check)
    {:noreply, {stream, last_modified, position}}
  end

  defp cast_new_lines(stream, last_modified, position) do
    cond do
      # ファイルが存在しない場合はスルー
      !File.exists?(stream.path) ->
        {last_modified, position}
      # ファイルが前回チェック時より更新されていない場合もスルー
      File.stat!(stream.path).mtime == last_modified ->
        # カレントポジションはアップデートしておきます
        {last_modified, length(Enum.into(stream, []))}
      true ->
        # パイプライン演算子を使って、カレントポジション以降の行をリスト化
        lines = stream
        |> Stream.drop(position)
        |> Enum.into([])
        if (length(lines) > 0) do
          # "tails:sample" チャンネルに行のリストを broadcast
          PhoenixTail.Endpoint.broadcast! "tails:sample", "new_lines", %{lines: lines}
        end
        # 最終更新日時とカレントポジションをアップデートしておきます
        {File.stat!(stream.path).mtime, position + length(lines)}
    end
  end
end
