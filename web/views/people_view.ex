defmodule Cineaste.PeopleView do
  use Cineaste.Web, :view

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

end