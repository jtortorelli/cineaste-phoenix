defmodule Cineaste.CommonViewTest do
  use CineasteWeb.ConnCase, async: true
  import Phoenix.View

  test "renders table row" do
    render_to_string(CineasteWeb.CommonView, "table_row.html", key: "key", value: "value") ==
      "<tr><td>key</td><td>value</td></tr>"
  end

  test "renders alias table row" do
    render_to_string(CineasteWeb.CommonView, "aliases.html", aliases: ["alias1", "alias2"]) ==
      "<tr><td>Aliases</td><td>alias1<br/>alias2<br/></td></tr>"
  end
end
