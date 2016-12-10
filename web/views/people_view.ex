defmodule Cineaste.PeopleView do
  use Cineaste.Web, :view
  alias Cineaste.CommonView

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
  
  def render_person_info(person) do
    render "person_info.html", person: person 
  end
  
  def render_original_name(%{"original_name" => original_name}) do
     CommonView.render_table_row("Original Name", raw original_name)
  end 
  
  def render_original_name(_) do
    nil
  end
  
  def render_birth_name(%{"birth_name" => birth_name}) do
    CommonView.render_table_row("Birth Name", raw birth_name) 
  end
  
  def render_birth_name(_) do
    nil 
  end
  
  def render_japanese_name(%{"japanese_name" => japanese_name}) do
    CommonView.render_table_row("Japanese Name", raw japanese_name) 
  end
  
  def render_japanese_name(_) do
    nil 
  end
  
  def render_aliases([_head | _tail] = aliases) do
     CommonView.render_aliases_table_row(aliases)
  end
  
  def render_aliases(_) do
    nil 
  end

end