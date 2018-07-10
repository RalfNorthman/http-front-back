defmodule Back do
  use Ace.HTTP.Service, port: 8080, cleartext: true
  use Raxx.Logger, level: :debug

  @impl Raxx.Server
  def handle_request(%{method: :GET, path: [head | _tail]}, _state) do
    body = String.reverse(head)

    response(:ok)
    |> set_header("content-type", "text/plain; charset=UTF-8")
    |> set_body(body)
  end

  def handle_request(%{method: :GET, path: []}, _state) do
    body = "Skriv något efter snedstrecket i URL:en!"

    response(:ok)
    |> set_header("content-type", "text/plain; charset=UTF-8")
    |> set_body(body)
  end
end
