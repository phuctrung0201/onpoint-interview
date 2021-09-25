defmodule ShopeeCrawlerWeb.PageController do
  use ShopeeCrawlerWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    item_limit="60"
    items_list_endpoint = "https://shopee.vn/api/v4/search/search_items?by=pop&limit=#{item_limit}&match_id=88201679&newest=0&order=desc&page_type=shop&scenario=PAGE_OTHERS&version=2"
    items = Crawler.fetch(items_list_endpoint)

    render(conn, "index.html", items: items)
  end
end
