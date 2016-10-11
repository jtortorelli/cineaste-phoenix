alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

matango = Repo.one from f in Film, where: f.title == "Matango"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
shinichi_hoshi = Repo.one(by_name.("Shinichi", "Hoshi"))
masami_fukushima = Repo.one(by_name.("Masami", "Fukushima"))
william_hodgson = Repo.one(by_name.("William", "Hodgson"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
shigekazu_ikuno = Repo.one(by_name.("Shigekazu", "Ikuno"))
fumio_yanoguchi = Repo.one(by_name.("Fumio", "Yanoguchi"))
shoshichi_kojima = Repo.one(by_name.("Shoshichi", "Kojima"))
sadao_bekku = Repo.one(by_name.("Sadao", "Bekku"))
reiko_kaneko = Repo.one(by_name.("Reiko", "Kaneko"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: matango.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: shinichi_hoshi.id,
    role: "Original Story",
    order: 2
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: masami_fukushima.id,
    role: "Original Story",
    order: 3
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: william_hodgson.id,
    role: "Original Story",
    order: 4
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 5
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 6
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: shigekazu_ikuno.id,
    role: "Art Director",
    order: 7
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: fumio_yanoguchi.id,
    role: "Sound Recording",
    order: 8
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: shoshichi_kojima.id,
    role: "Lighting",
    order: 9
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: sadao_bekku.id,
    role: "Music",
    order: 10
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: reiko_kaneko.id,
    role: "Editor",
    order: 13
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 17
  },
  %StaffPersonRole{
    film_id: matango.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 24
  }
]

from(role in StaffPersonRole, where: role.film_id == ^matango.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
