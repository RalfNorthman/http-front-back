defmodule Back do
  use Ace.HTTP.Service, port: 8081, cleartext: true
  use Raxx.Logger, level: :debug

  @impl Raxx.Server
  def handle_request(%{method: :GET, path: [head | _tail]}, _state) do
    body = String.reverse(head)

    response(:ok)
    |> set_header("content-type", "text/plain; charset=UTF-8")
    |> set_header("access-control-allow-origin", "*")
    |> set_body(body)
  end

  def handle_request(%{method: :POST, path: [], body: body}, _state) do
    new_body =
      body
      |> Jason.decode!()
      |> Map.update!("someText", fn s -> String.reverse(s) end)
      |> Jason.encode!()

    response(:ok)
    |> set_header("content-type", "application/json; charset=UTF-8")
    |> set_header("access-control-allow-origin", "*")
    |> set_body(new_body)
  end

  def handle_request(%{method: :OPTIONS, path: []}, _state) do
    response(:ok)
    |> set_header("accept", "*.*")
    |> set_header(
      "access-control-allow-methods",
      "POST, GET, OPTIONS"
    )
    |> set_header("access-control-allow-headers", "*")
    |> set_header("access-control-allow-origin", "*")
    |> set_body("")
  end
end
