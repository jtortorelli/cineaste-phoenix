alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

taklamakan = Repo.one from f in Film, where: f.title == "The Adventure of Taklamakan"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

senkichi_taniguchi = Repo.one(by_name.("Senkichi","Taniguchi"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
hiroshi_nezu = Repo.one(by_name.("Hiroshi", "Nezu"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
osamu_dazai = Repo.one(by_name.("Osamu", "Dazai"))
kazuo_yamada = Repo.one(by_name.("Kazuo", "Yamada"))
hiroshi_ueda = Repo.one(by_name.("Hiroshi", "Ueda"))
yoshio_nishikawa = Repo.one(by_name.("Yoshio", "Nishikawa"))
hiromitsu_mori = Repo.one(by_name.("Hiromitsu", "Mori"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
yoshitami_kuroiwa = Repo.one(by_name.("Yoshitami", "Kuroiwa"))


roles = [
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: senkichi_taniguchi.id,
    role: "Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: hiroshi_nezu.id,
    role: "Assistant Producer",
    order: 2
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 3
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: osamu_dazai.id,
    role: "Original Story",
    order: 4
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: kazuo_yamada.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: hiroshi_ueda.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: yoshio_nishikawa.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: hiromitsu_mori.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: taklamakan.id,
    person_id: yoshitami_kuroiwa.id,
    role: "Editor",
    order: 12
  }
]

from(role in StaffPersonRole, where: role.film_id == ^taklamakan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
