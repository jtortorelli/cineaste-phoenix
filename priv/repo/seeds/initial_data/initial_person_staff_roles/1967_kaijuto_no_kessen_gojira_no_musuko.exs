alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

son_of_godzilla = Repo.one from f in Film, where: f.title == "Son of Godzilla"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

jun_fukuda = Repo.one(by_name.("Jun", "Fukuda"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
kazue_shiba = Repo.one(by_name.("Kazue", "Shiba"))
kazuo_yamada = Repo.one(by_name.("Kazuo", "Yamada"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
shin_watarai = Repo.one(by_name.("Shin", "Watarai"))
toshiya_ban = Repo.one(by_name.("Toshiya", "Ban"))
takeji_yamaguchi = Repo.one(by_name.("Takeji", "Yamaguchi"))
shoshichi_kojima = Repo.one(by_name.("Shoshichi", "Kojima"))
masaru_sato = Repo.one(by_name.("Masaru", "Sato"))
ryohei_fujii = Repo.one(by_name.("Ryohei", "Fujii"))
yasuyuki_inoue = Repo.one(by_name.("Yasuyuki", "Inoue"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: jun_fukuda.id,
    role: "Director",
    order: -3
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Supervisor",
    order: -1
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 2
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: kazue_shiba.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: kazuo_yamada.id,
    role: "Cinematography",
    order: 4
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: shin_watarai.id,
    role: "Sound Recording",
    order: 6
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: toshiya_ban.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: takeji_yamaguchi.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: shoshichi_kojima.id,
    role: "Lighting",
    order: 9
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: masaru_sato.id,
    role: "Music",
    order: 10
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: ryohei_fujii.id,
    role: "Editor",
    order: 13
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: yasuyuki_inoue.id,
    role: "Special Effects Art Director",
    order: 20
  },
  %StaffPersonRole{
    film_id: son_of_godzilla.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 24
  }
]

from(role in StaffPersonRole, where: role.film_id == ^son_of_godzilla.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
