alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

invisible_man = Repo.one from f in Film, where: f.title == "The Invisible Man"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

seizaburo_kawazu = by_name.("Seizaburo", "Kawazu")
miki_sanjo = by_name.("Miki", "Sanjo")
minoru_takada = by_name.("Minoru", "Takada")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
kenjiro_uemura = by_name.("Kenjiro", "Uemura")
kamatari_fujiwara = by_name.("Kamatari", "Fujiwara")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
yo_shiomi = by_name.("Yo", "Shiomi")
sonosuke_sawamura = by_name.("Sonosuke", "Sawamura")
seijiro_onda = by_name.("Seijiro", "Onda")
shin_otomo = by_name.("Shin", "Otomo")
keiko_kondo = by_name.("Keiko", "Kondo")
fuminto_matsuo = by_name.("Fuminto", "Matsuo")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
haruo_suzuki = by_name.("Haruo", "Suzuki")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
yutaka_sada = by_name.("Yutaka", "Sada")
haruo_nakajima = by_name.("Haruo", "Nakajima")
akira_sera = by_name.("Akira", "Sera")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
yutaka_oka = by_name.("Yutaka", "Oka")
shoichi_hirose = by_name.("Shoichi", "Hirose")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
minoru_ito = by_name.("Minoru", "Ito")
keiji_sakakida = by_name.("Keiji", "Sakakida")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
junichiro_mukai = by_name.("Junichiro", "Mukai")
kazuo_hinata = by_name.("Kazuo", "Hinata")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
koji_uno = by_name.("Koji", "Uno")
ken_echigo = by_name.("Ken", "Echigo")

roles = [
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: seizaburo_kawazu.id,
    roles: ["Nanjo"],
    order: 1
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: miki_sanjo.id,
    roles: ["Michiyo"],
    order: 2
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: minoru_takada.id,
    roles: ["Yajima"],
    order: 3
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Komatsu"],
    order: 4
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: kenjiro_uemura.id,
    roles: ["Ken"],
    order: 5
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: kamatari_fujiwara.id,
    roles: ["Mari's Grandfather"],
    order: 6
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: fuyuki_murakami.id,
    roles: ["Newspaper Editor"],
    order: 7
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: yo_shiomi.id,
    roles: ["Scientist"],
    order: 8
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: sonosuke_sawamura.id,
    roles: ["Parliamentarian"],
    order: 9
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: seijiro_onda.id,
    roles: ["Commissioner"],
    order: 10
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: shin_otomo.id,
    roles: ["Police Chief"],
    order: 11
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: keiko_kondo.id,
    roles: ["Mari"],
    order: 13
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: fuminto_matsuo.id,
    roles: ["Yajima's Henchman"],
    order: 14
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: yutaka_nakayama.id,
    roles: ["Yajima's Henchman"],
    order: 15
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: haruo_suzuki.id,
    roles: ["Yajima's Henchman"],
    order: 18
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Parliamentarian"],
    order: 21
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: yutaka_sada.id,
    roles: ["Bus Passenger", "Nightclub Mascot"],
    order: 22
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: haruo_nakajima.id,
    roles: ["Suicidal Invisible Man"],
    order: 23
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: akira_sera.id,
    roles: ["Food Stand Chef"],
    order: 24
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Nightclub Patron"],
    order: 25
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: yutaka_oka.id,
    roles: ["Newsreader"],
    order: 27
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: shoichi_hirose.id,
    roles: ["Policeman"],
    order: 28
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Jewelry Store Clerk"],
    order: 29
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: takuzo_kumagai.id,
    roles: ["Parliamentarian"],
    order: 30
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: minoru_ito.id,
    roles: ["Driver"],
    order: 32
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: keiji_sakakida.id,
    roles: ["Policeman"],
    order: 33
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: haruya_sakamoto.id,
    roles: ["Detective", "Bus Passenger"],
    order: 99
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: junichiro_mukai.id,
    roles: ["Detective", "Bus Passenger"],
    order: 99
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: kazuo_hinata.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Bus Passenger"],
    order: 99
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: koji_uno.id,
    roles: ["Bus Driver", "Detective"],
    order: 99
  },
  %ActorPersonRole{
    film_id: invisible_man.id,
    person_id: ken_echigo.id,
    roles: ["Waiter"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^invisible_man.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
