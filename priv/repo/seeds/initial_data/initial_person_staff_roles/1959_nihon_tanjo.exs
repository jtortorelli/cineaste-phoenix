alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

birth_of_japan = Repo.one from f in Film, where: f.title == "The Birth of Japan"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

hiroshi_inagaki = Repo.one(by_name.("Hiroshi", "Inagaki"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
sanezumi_fujimoto = Repo.one(by_name.("Sanezumi", "Fujimoto"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
toshio_yasumi = Repo.one(by_name.("Toshio", "Yasumi"))
ryuzo_kikushima = Repo.one(by_name.("Ryuzo", "Kikushima"))
kisaku_ito = Repo.one(by_name.("Kisaku", "Ito"))
kazuo_yamada = Repo.one(by_name.("Kazuo", "Yamada"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
yoshio_nishikawa = Repo.one(by_name.("Yoshio", "Nishikawa"))
hisashi_shimonaga = Repo.one(by_name.("Hisashi", "Shimonaga"))
shoshichi_kojima = Repo.one(by_name.("Shoshichi", "Kojima"))
kazuji_taira = Repo.one(by_name.("Kazuji", "Taira"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))

roles = [
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: hiroshi_inagaki.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: sanezumi_fujimoto.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 2
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: toshio_yasumi.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: ryuzo_kikushima.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: kisaku_ito.id,
    role: "Art Director",
    order: 5
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: kazuo_yamada.id,
    role: "Cinematography",
    order: 6
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 7
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: yoshio_nishikawa.id,
    role: "Sound Recording",
    order: 9
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: hisashi_shimonaga.id,
    role: "Sound Recording",
    order: 10
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: shoshichi_kojima.id,
    role: "Lighting",
    order: 11
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: kazuji_taira.id,
    role: "Editor",
    order: 13
  },
  %StaffPersonRole{
    film_id: birth_of_japan.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 17
  }
]

from(role in StaffPersonRole, where: role.film_id == ^birth_of_japan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
