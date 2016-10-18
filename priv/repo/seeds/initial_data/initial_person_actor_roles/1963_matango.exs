alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

matango = Repo.one from f in Film, where: f.title == "Matango"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

akira_kubo = by_name.("Akira", "Kubo")
kumi_mizuno = by_name.("Kumi", "Mizuno")
hiroshi_koizumi = by_name.("Hiroshi", "Koizumi")
kenji_sahara = by_name.("Kenji", "Sahara")
hiroshi_tachikawa = by_name.("Hiroshi", "Tachikawa")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
miki_yashiro = by_name.("Miki", "Yashiro")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
akio_kusama = by_name.("Akio", "Kusama")
yutaka_oka = by_name.("Yutaka", "Oka")
keisuke_yamada = by_name.("Keisuke", "Yamada")
kazuo_hinata = by_name.("Kazuo", "Hinata")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
masaki_shinohara = by_name.("Masaki", "Shinohara")

roles = [
  %ActorPersonRole{
    film_id: matango.id,
    person_id: akira_kubo.id,
    roles: ["Kenji Murai"],
    order: 1
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: kumi_mizuno.id,
    roles: ["Mami Sekiguchi"],
    order: 2
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: hiroshi_koizumi.id,
    roles: ["Naoyuki Sakuta"],
    order: 3
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: kenji_sahara.id,
    roles: ["Senzo Koyama"],
    order: 4
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: hiroshi_tachikawa.id,
    roles: ["Etsuro Yoshida"],
    order: 5
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Masafumi Kasai"],
    order: 6
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: miki_yashiro.id,
    roles: ["Akiko Soma"],
    order: 7
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: hideyo_amamoto.id,
    roles: ["Mushroom Man"],
    order: 8
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: takuzo_kumagai.id,
    roles: ["Doctor"],
    order: 9
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: akio_kusama.id,
    roles: ["Official"],
    order: 10
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: yutaka_oka.id,
    roles: ["Doctor"],
    order: 11
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: keisuke_yamada.id,
    roles: ["Doctor"],
    order: 12
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: kazuo_hinata.id,
    roles: ["Official"],
    order: 13
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: katsumi_tezuka.id,
    roles: ["Official"],
    order: 14
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: haruo_nakajima.id,
    roles: ["Mushroom Man"],
    order: 15
  },
  %ActorPersonRole{
    film_id: matango.id,
    person_id: masaki_shinohara.id,
    roles: ["Mushroom Man"],
    order: 18
  }
]

from(role in ActorPersonRole, where: role.film_id == ^matango.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
