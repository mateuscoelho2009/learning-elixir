defmodule Esl do
  @behaviour Crawly.Spider

  @impl Crawly.Spider
  def base_url() do
    [
      "https://www.zapimoveis.com.br/",
      "http://www.zapimoveis.com.br/",
    ]
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://www.zapimoveis.com.br/aluguel/apartamentos/sp+sao-jose-dos-campos++jd-s-dimas/",
        "https://www.zapimoveis.com.br/aluguel/flat/sp+sao-jose-dos-campos++jd-s-dimas/",
      ],
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # Getting new urls to follow
    urls =
      response.body
      |> Floki.find("a")
      |> Floki.attribute("href")
      |> Enum.filter(fn url ->
          String.contains?(url, "imovel") # or String.contains?(url, "apartamentos") or String.contains?(url, "flat")
        end)

    # Convert URLs into requests
    requests =
      Enum.map(urls, fn url ->
        url
        |> build_absolute_url(response.request_url)
        |> Crawly.Utils.request_from_url()
      end)

    # Extract item from a page, e.g.
    # https://www.erlang-solutions.com/blog/introducing-telemetry.html
    rent =
      response.body
      |> Floki.find("li.total")
      |> Floki.text()

    iptu =
      response.body
      |> Floki.find("li.iptu")
      |> Floki.text()

    address = Floki.find(response.body, "span.link") |> Floki.text()

    %Crawly.ParsedItem{
      :requests => requests,
      :items => [
        %{rent: rent, iptu: iptu, address: address, url: response.request_url}
      ]
    }
  end

  def build_absolute_url(url, request_url) do
    URI.merge(request_url, url)
      |> to_string()
  end
end
