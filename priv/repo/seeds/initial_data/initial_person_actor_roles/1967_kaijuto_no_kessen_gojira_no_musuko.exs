alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

son_of_godzilla = Repo.one from f in Film, where: f.title == "Son of Godzilla"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

tadao_takashima = by_name.("Tadao", "Takashima")
beverly_maeda = by_name.("Beverly", "Maeda")
akira_kubo = by_name.("Akira", "Kubo")
akihiko_hirata = by_name.("Akihiko", "Hirata")
kenji_sahara = by_name.("Kenji", "Sahara")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
susumu_kurobe = by_name.("Susumu", "Kurobe")
kazuo_suzuki = by_name.("Kazuo", "Suzuki")
kenichiro_maruyama = by_name.("Kenichiro", "Maruyama")
seishiro_kuno = by_name.("Seishiro", "Kuno")
yasuhiko_saijo = by_name.("Yasuhiko", "Saijo")
chotaro_togin = by_name.("Chotaro", "Togin")
wataru_omae = by_name.("Wataru", "Omae")
seiji_onaka = by_name.("Seiji", "Onaka")
hiroshi_sekida = by_name.("Hiroshi", "Sekida")
haruo_nakajima = by_name.("Haruo", "Nakajima")
masao_fukasawa = by_name.("Masao", "Fukasawa")
osman_yusef = by_name.("Osman", "Yusef")

roles = [
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: tadao_takashima.id,
    roles: ["Dr. Kusumi"],
    order: 1
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: beverly_maeda.id,
    roles: ["Saeko"],
    order: 2
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: akira_kubo.id,
    roles: ["Goro Maki"],
    order: 3
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: akihiko_hirata.id,
    roles: ["Fujisaki"],
    order: 4
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: kenji_sahara.id,
    roles: ["Morio"],
    order: 5
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Furukawa"],
    order: 6
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: susumu_kurobe.id,
    roles: ["Pilot"],
    order: 7
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: kazuo_suzuki.id,
    roles: ["Pilot"],
    order: 8
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: kenichiro_maruyama.id,
    roles: ["Ozawa"],
    order: 9
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: seishiro_kuno.id,
    roles: ["Tashiro"],
    order: 10
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: yasuhiko_saijo.id,
    roles: ["Suzuki"],
    order: 11
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: chotaro_togin.id,
    roles: ["Pilot"],
    order: 12
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: wataru_omae.id,
    roles: ["Pilot"],
    order: 13
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: seiji_onaka.id,
    roles: ["Godzilla"],
    order: 14
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: hiroshi_sekida.id,
    roles: ["Godzilla"],
    order: 15
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla"],
    order: 16
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: masao_fukasawa.id,
    roles: ["Minya"],
    order: 17
  },
  %ActorPersonRole{
    film_id: son_of_godzilla.id,
    person_id: osman_yusef.id,
    roles: ["Submarine Officer"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^son_of_godzilla.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
