defmodule ShopeeCrawlerWeb.PageController do
  use ShopeeCrawlerWeb, :controller
  @items_list_enpoint "https://shopee.vn/api/v4/search/search_items?by=pop&limit=30&match_id=88201679&newest=0&order=desc&page_type=shop&scenario=PAGE_OTHERS&version=2"
  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    items = Crawler.fetch(@items_list_enpoint)
    render(conn, "index.html", items: items)
  end
end
