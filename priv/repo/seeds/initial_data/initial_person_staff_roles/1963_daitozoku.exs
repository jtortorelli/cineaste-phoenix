alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

samurai_pirate = Repo.one from f in Film, where: f.title == "Samurai Pirate"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

senkichi_taniguchi = Repo.one(by_name.("Senkichi","Taniguchi"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
kenichiro_tsunoda = Repo.one(by_name.("Kenichiro","Tsunoda"))
toshio_yasumi = Repo.one(by_name.("Toshio", "Yasumi"))
kaoru_mabuchi = Repo.one(by_name.("Kaoru","Mabuchi"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
takao_saito = Repo.one(by_name.("Takao","Saito"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
shin_watarai = Repo.one(by_name.("Shin", "Watarai"))
norikazu_onda = Repo.one(by_name.("Norikazu", "Onda"))
masaru_sato = Repo.one(by_name.("Masaru", "Sato"))
yoshitami_kuroiwa = Repo.one(by_name.("Yoshitami", "Kuroiwa"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: senkichi_taniguchi.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: kenichiro_tsunoda.id,
    role: "Producer",
    order: 2
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: toshio_yasumi.id,
    role: "Story Coordinator",
    order: 3
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: kaoru_mabuchi.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 5
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: takao_saito.id,
    role: "Cinematography",
    order: 6
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 7
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: shin_watarai.id,
    role: "Sound Recording",
    order: 8
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: norikazu_onda.id,
    role: "Lighting",
    order: 9
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: masaru_sato.id,
    role: "Music",
    order: 10
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: yoshitami_kuroiwa.id,
    role: "Editor",
    order: 13
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 18
  },
  %StaffPersonRole{
    film_id: samurai_pirate.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 25
  }
]

from(role in StaffPersonRole, where: role.film_id == ^samurai_pirate.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
