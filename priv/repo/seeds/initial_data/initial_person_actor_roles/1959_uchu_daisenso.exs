alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

battle_in_outer_space = Repo.one from f in Film, where: f.title == "Battle in Outer Space"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

ryo_ikebe = by_name.("Ryo", "Ikebe")
kyoko_anzai = by_name.("Kyoko", "Anzai")
minoru_takada = by_name.("Minoru", "Takada")
koreya_senda = by_name.("Koreya", "Senda")
leonard_stanford = by_name.("Leonard", "Stanford")
harold_conway = by_name.("Harold", "Conway")
george_wyman = by_name.("George", "Wyman")
elise_richter = by_name.("Elise", "Richter")
hisaya_ito = by_name.("Hisaya", "Ito")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
nadao_kirino = by_name.("Nadao", "Kirino")
kozo_nomura = by_name.("Kozo", "Nomura")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
ikio_sawamura = by_name.("Ikio", "Sawamura")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
tadashi_okabe = by_name.("Tadashi", "Okabe")
osman_yusef = by_name.("Osman", "Yusef")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
keisuke_yamada = by_name.("Keisuke", "Yamada")
yutaka_oka = by_name.("Yutaka", "Oka")
shigeo_kato = by_name.("Shigeo", "Kato")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
andrew_hughes = by_name.("Andrew", "Hughes")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
haruo_suzuki = by_name.("Haruo", "Suzuki")
kazuo_hinata = by_name.("Kazuo", "Hinata")
junichiro_mukai = by_name.("Junichiro", "Mukai")
keiji_sakakida = by_name.("Keiji", "Sakakida")
minoru_ito = by_name.("Minoru", "Ito")
obel_wyatt = by_name.("Obel", "Wyatt")
saburo_iketani = by_name.("Saburo", "Iketani")
yoshio_katsube = by_name.("Yoshio", "Katsube")

roles = [
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: ryo_ikebe.id,
    roles: ["Major Ichiro Katsumiya"],
    order: 1
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: kyoko_anzai.id,
    roles: ["Etsuko Shiraishi"],
    order: 2
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: minoru_takada.id,
    roles: ["Defense Commander"],
    order: 3
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: koreya_senda.id,
    roles: ["Dr. Adachi"],
    order: 4
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: leonard_stanford.id,
    roles: ["Dr. Richardson"],
    order: 5
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: harold_conway.id,
    roles: ["Dr. Immelman"],
    order: 6
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: george_wyman.id,
    roles: ["Dr. Ahmed"],
    order: 7
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: elise_richter.id,
    roles: ["Sylvia"],
    order: 8
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: hisaya_ito.id,
    roles: ["Astronaut Kogure"],
    order: 9
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Astronaut Iwamura"],
    order: 10
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: nadao_kirino.id,
    roles: ["Astronaut Okada"],
    order: 11
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: kozo_nomura.id,
    roles: ["Space Jet Pilot"],
    order: 12
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: fuyuki_murakami.id,
    roles: ["Detective Iriake"],
    order: 13
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: ikio_sawamura.id,
    roles: ["Line Inspector"],
    order: 14
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: takuzo_kumagai.id,
    roles: ["Military Officer"],
    order: 15
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: katsumi_tezuka.id,
    roles: ["Military Officer"],
    order: 16
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Military Officer"],
    order: 17
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: tadashi_okabe.id,
    roles: ["Military Officer"],
    order: 18
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: osman_yusef.id,
    roles: ["Astronaut"],
    order: 19
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Train Conductor"],
    order: 24
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: rinsaku_ogata.id,
    roles: ["Astronaut"],
    order: 28
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: keisuke_yamada.id,
    roles: ["UN Official"],
    order: 29
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: yutaka_oka.id,
    roles: ["Astronaut"],
    order: 31
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: shigeo_kato.id,
    roles: ["Train Conductor"],
    order: 32
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: yukihiko_gondo.id,
    roles: ["Space Station Crew"],
    order: 34
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: andrew_hughes.id,
    roles: ["UN Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: haruya_sakamoto.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: haruo_suzuki.id,
    roles: ["Detective"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: kazuo_hinata.id,
    roles: ["UN Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: junichiro_mukai.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: keiji_sakakida.id,
    roles: ["UN Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: minoru_ito.id,
    roles: ["Speaker"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: obel_wyatt.id,
    roles: ["Military Officer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: saburo_iketani.id,
    roles: ["Newsreader"],
    order: 99
  },
  %ActorPersonRole{
    film_id: battle_in_outer_space.id,
    person_id: yoshio_katsube.id,
    roles: ["Attendant"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^battle_in_outer_space.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
