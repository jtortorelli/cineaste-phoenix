defmodule CineasteWeb.PeopleView do
  use Cineaste.Web, :view
  alias CineasteWeb.CommonView
  alias Cineaste.Person
  alias CineasteWeb.S3View

  def render_link(view) do
    case view.type do
      "person" ->
        family_name = Enum.at(view.display_name, 0)
        given_name = Enum.at(view.display_name, 1)
        raw "<a href=\"/people/person/#{view.id}\"><span class=\"table-header\">#{family_name}</span> #{given_name}</a>"
      "group" ->
        raw "<a href=\"/people/group/#{view.id}\"><span class=\"table-header\">#{view.display_name}</span></a>"
    end
  end

  def render_image_link(view) do
    case view.type do
      "person" ->
        raw "<a href=\"/people/person/#{view.id}\"><img class=\"img-circle shadowed\" src=\"#{render_person_profile_pic(view.id)}\" height=\"100px\" width=\"100px\"></a>"
      "group" ->
        raw "<a href=\"/people/group/#{view.id}\"><img class=\"img-circle shadowed\" src=\"#{render_group_profile_pic(view.id)}\" height=\"100px\" width=\"100px\"></a>"
    end
  end

  def render_view_roles(view) do
    Enum.map(view.roles, fn(x) -> convert_role_to_display_value(x, view) end)
    |> Enum.join("<br/>")
  end

  defp convert_role_to_display_value("Actor", %{gender: "F"}) do
    "Actress"
  end

  defp convert_role_to_display_value("Actor", %{type: "group"}) do
    "Performers"
  end

  defp convert_role_to_display_value("Special Effects Supervisor", _) do
    "SFX Supervisor"
  end

  defp convert_role_to_display_value("Cinematography", _) do
    "Cinematographer"
  end

  defp convert_role_to_display_value("Special Effects Cinematography", _) do
    "SFX Cinematographer"
  end

  defp convert_role_to_display_value("Special Effects Director", _) do
    "SFX Director"
  end

  defp convert_role_to_display_value("Special Effects Assistant Director", _) do
    "SFX A.D."
  end

  defp convert_role_to_display_value("Music", _) do
    "Composer"
  end

  defp convert_role_to_display_value("Original Story", _) do
    "Author"
  end

  defp convert_role_to_display_value("Screenplay", _) do
    "Screenwriter"
  end

  defp convert_role_to_display_value("Special Effects Art Director", _) do
    "SFX Art Director"
  end

  defp convert_role_to_display_value(role, _) do
    role
  end

  def render_index_display_name([family_name | [given_name | []]]) do
    "<span class=\"table-header\">#{family_name}</span><br/>#{given_name}"
  end

  def render_index_display_name([group_name | []]) do
    "<span class=\"table-header\">#{group_name}</span>"
  end

  def render_person_profile_pic(person_id) do
    S3View.get_profile_pic("person", person_id)
  end

  def render_group_profile_pic(group_id) do
    S3View.get_profile_pic("group", group_id)
  end

  def render_person_info(person), do: render "person_info.html", person: person

  def render_original_name(%{"original_name" => original_name}), do: CommonView.render_table_row("Original Name", raw original_name)
  def render_original_name(_), do: nil

  def render_birth_name(%{"birth_name" => birth_name}), do: CommonView.render_table_row("Birth Name", raw birth_name)
  def render_birth_name(_), do: nil

  def render_japanese_name(%{"japanese_name" => japanese_name}), do: CommonView.render_table_row("Japanese Name", raw japanese_name)
  def render_japanese_name(_), do: nil

  def render_aliases([_head | _tail] = aliases), do: CommonView.render_aliases_table_row(aliases)
  def render_aliases(_), do: nil

  defp create_display_date(%{"year" => year, "month" => month, "day" => day}) do
     {:ok, date} = Date.new(year, month, day)
     Timex.format!(date, "{Mfull} {D}, {YYYY}")
  end

  defp create_display_date(%{"year" => year, "month" => month}) do
    {:ok, date} = Date.new(year, month, 1)
    Timex.format!(date, "{Mfull}, {YYYY}")
  end

  defp create_display_date(%{"year" => year}) do
    {:ok, date} = Date.new(year, 1, 1)
    Timex.format!(date, "{YYYY}")
  end

  def render_dates(%Person{dob: %{}, dod: nil} = person) do
    render "person_dates_living.html", dob: create_display_date(person.dob), age: Person.age(person), birth_place: person.birth_place
  end

  def render_dates(%Person{dob: %{}, dod: %{"unknown" => _unknown}} = person) do
    render "person_dates_unknown_dod.html", dob: create_display_date(person.dob), birth_place: person.birth_place
  end

  def render_dates(%Person{dob: %{}, dod: %{}} = person) do
    render "person_dates_deceased.html", dob: create_display_date(person.dob), dod: create_display_date(person.dod), age: Person.age(person), birth_place: person.birth_place, death_place: person.death_place
  end

  def render_dates(_), do: nil

  def render_selected_filmography(conn, roles) do
    role_names = Enum.map(roles, fn r -> r.role end) |> Enum.uniq
    role_groups = Enum.reduce(role_names, %{}, fn role_name, acc -> Map.put(acc, role_name, Enum.filter(roles, fn r -> r.role == role_name end)) end)
    render "selected_filmography_roles.html", conn: conn, role_names: role_names, role_groups: role_groups
  end

  def render_film_link(conn, %{film_id: id, film_title: title, film_release_date: date, film_showcase: true, characters: characters}, "Actor") do
    {:safe, link_text} = link raw("<i>#{title}</i> (#{date.year})"), to: film_path(conn, :show, id)
    raw "#{link_text} <span class=\"subdue\">... #{Enum.join(characters, ", ")}</span>"
  end

  def render_film_link(_conn, %{film_id: _id, film_title: title, film_release_date: date, film_showcase: false, characters: characters}, "Actor") do
    raw "<i>#{title}</i> (#{date.year}) <span class=\"subdue\">... #{Enum.join(characters, ", ")}</span>"
  end

  def render_film_link(conn, %{film_id: id, film_title: title, film_release_date: date, film_showcase: true}, _role_name) do
    link raw("<i>#{title}</i> (#{date.year})"), to: film_path(conn, :show, id)
  end

  def render_film_link(_conn, %{film_title: title, film_release_date: date, film_showcase: false}, _role_name) do
    raw "<i>#{title}</i> (#{date.year})"
  end

  def render_group_info(group), do: render "group_info.html", group: group

  def render_members([_head | _tail] = members) do
    joined_members = Enum.map(members, fn x -> "#{x.given_name} #{x.family_name}" end)
    |> Enum.join("<br/>")
    CommonView.render_table_row("Members", joined_members)
  end

  def render_members(_), do: nil

  def render_group_active_period(start_date, nil) do
    period = "#{start_date} - Present"
    CommonView.render_table_row("Active Period", period)
  end

  def render_group_active_period(nil, nil), do: nil

  def render_group_active_period(start_date, end_date) do
    period = "#{start_date} - #{end_date}"
    CommonView.render_table_row("Active Period", period)
  end

  def filter_people_list(people_list, searchTerm) do
    searchTerms = String.split(searchTerm)
    Enum.filter(people_list, fn(p) -> filter_people(p, searchTerms) end)
  end

  def filter_people(%{type: "person"} = person_view, searchTerms) do
    containsSearchTerm(Enum.join(person_view.display_name, " "), searchTerms) or containsSearchTerm(person_view.aliases, searchTerms)
  end

  def filter_people(%{type: "group"} = group_view, searchTerms) do
    containsSearchTerm(Enum.at(group_view.display_name, 0), searchTerms) or containsSearchTerm(group_view.members, searchTerms)
  end

  def containsSearchTerm(nil, _) do
    false
  end

  def containsSearchTerm([_h | _t] = fields, searchTerms) do
    Enum.any?(fields, fn(f) -> containsSearchTerm(f, searchTerms) end)
  end

  def containsSearchTerm(field, searchTerms) do
    Enum.all?(searchTerms, fn(term) -> String.contains?(String.downcase(field), String.downcase(term)) end)
  end

  def render_back_button, do: CommonView.render_back_button

end
