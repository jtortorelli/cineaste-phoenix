defmodule Cineaste.PeopleView do
  use Cineaste.Web, :view
  alias Cineaste.CommonView
  alias Cineaste.Person

  def render_link(conn, view) do
    case view.type do
      "person" ->
        link "#{view.display_name}", to: people_path(conn, :show_person, view.id)
      "group" ->
        link "#{view.display_name}", to: people_path(conn, :show_group, view.id)
    end
  end

  def render_person_profile_pic(person_id) do
    s3_person_profile_pic_url = Application.get_env(:cineaste, :s3)[:base_url] <> Application.get_env(:cineaste, :s3)[:person_profiles]
    s3_person_profile_pic_url <> person_id <> ".jpg"
  end

  def render_group_profile_pic(group_id) do
    s3_group_profile_pic_url = Application.get_env(:cineaste, :s3)[:base_url] <> Application.get_env(:cineaste, :s3)[:group_profiles]
    s3_group_profile_pic_url <> group_id <> ".jpg"
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

  def render_dates(%Person{dob: %{}, dod: %{"unknown" => unknown}} = person) do
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
    {:safe, link_text} = link raw("<i>#{title}</i> (#{Timex.format!(date, "{YYYY}")})"), to: film_path(conn, :show, id)
    raw "<span class=\"subdue\">#{link_text} ... #{Enum.join(characters, ", ")}</span>"
  end

  def render_film_link(conn, %{film_id: id, film_title: title, film_release_date: date, film_showcase: true}, _role_name) do
    link raw("<i>#{title}</i> (#{Timex.format!(date, "{YYYY}")})"), to: film_path(conn, :show, id)
  end

  def render_film_link(_conn, %{film_title: title, film_release_date: date, film_showcase: false}, _role_name) do
    raw "<i>#{title}</i> (#{Timex.format!(date, "{YYYY}")})"
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

end
