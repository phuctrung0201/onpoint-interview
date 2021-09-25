
defmodule Crawler do
  @spec fetch(binary) :: list
  def fetch(url) do
    response = Crawly.fetch(url)
    {:ok, document} = Floki.parse_document(response.body)
    get_data_from_document(document)
  end

  defp get_data_from_document(document) do
    {:ok, results} = Poison.decode(document)

    case results["error"] do
      nil ->
        Enum.map(results["items"],
        fn item ->
          item_info = item["item_basic"]
          item_info = Map.put(item_info, "detail_url", get_detail_url(item_info))
          # price = String.slice(Integer.to_string(item_info["price"]), 0..-6)
          # price_before_discount = String.slice(Integer.to_string(item_info["price_before_discount"]), 0..-6)



          %{
            item_info |
            "price" => div(item_info["price"], 1000),
            "price_before_discount" => div(item_info["price_before_discount"], 1000)
          }
        end)

      _ -> []
    end
  end

  defp get_detail_url(item_info) do
    name = String.replace(item_info["name"],~r/[^a-zA-Z0-9]/, "-")
    shop_id = Integer.to_string(item_info["shopid"])
    item_id = Integer.to_string(item_info["itemid"])
    "https://shopee.vn/-#{name}-i.#{shop_id}.#{item_id}"
  end
end
