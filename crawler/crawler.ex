
defmodule Crawler do
  @spec fetch(binary) :: list
  def fetch(url) do
    response = Crawly.fetch(url)
    {:ok, document} = Floki.parse_document(response.body)

    get_data_from_response(document)
  end

  defp get_data_from_response(document) do
    {:ok, results} = Poison.decode(document)

    case results["error"] do
      nil ->
        Enum.map(
          results["items"],
          fn item ->
            item_info = item["item_basic"]
            item_info = Map.put(item_info, "detail_url", get_detail_url_item(item_info))
            image = item_info["image"]

            # price = String.slice(Integer.to_string(item_info["price"]), 0..-6)

            # price_before_discount = String.slice(Integer.to_string(item_info["price_before_discount"]), 0..-6)

            %{item_info | "image" => "https://cf.shopee.vn/file/"<>image}
          end
        )

      _ -> []
    end
  end

  defp get_detail_url_item(item_info) do
    item_id = Integer.to_string(item_info["itemid"])
    shop_id = Integer.to_string(item_info["shopid"])
    item_name = String.replace(item_info["name"],~r/[^a-zA-Z0-9]/, "-")
    "https://shopee.vn/-#{item_name}-i.#{shop_id}.#{item_id}"
  end
end
