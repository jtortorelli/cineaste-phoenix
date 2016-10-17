alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

gorath = Repo.one from f in Film, where: f.title == "Gorath"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

ryo_ikebe = by_name.("Ryo", "Ikebe")
yumi_shirakawa = by_name.("Yumi", "Shirakawa")
akira_kubo = by_name.("Akira", "Kubo")
kumi_mizuno = by_name.("Kumi", "Mizuno")
hiroshi_tachikawa = by_name.("Hiroshi", "Tachikawa")
akihiko_hirata = by_name.("Akihiko", "Hirata")
kenji_sahara = by_name.("Kenji", "Sahara")
jun_tazaki = by_name.("Jun", "Tazaki")
ken_uehara = by_name.("Ken", "Uehara")
takashi_shimura = by_name.("Takashi", "Shimura")
seizaburo_kawazu = by_name.("Seizaburo", "Kawazu")
ko_mishima = by_name.("Ko", "Mishima")
sachio_sakai = by_name.("Sachio", "Sakai")
takamaru_sasaki = by_name.("Takamaru", "Sasaki")
ko_nishimura = by_name.("Ko", "Nishimura")
eitaro_ozawa = by_name.("Eitaro", "Ozawa")
masanari_nihei = by_name.("Masanari", "Nihei")
kozo_nomura = by_name.("Kozo", "Nomura")
keiko_sata = by_name.("Keiko", "Sata")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
george_furness = by_name.("George", "Furness")
ross_bennett = by_name.("Ross", "Bennett")
junichiro_mukai = by_name.("Junichiro", "Mukai")
nadao_kirino = by_name.("Nadao", "Kirino")
fumio_sakashita = by_name.("Fumio", "Sakashita")
ikio_sawamura = by_name.("Ikio", "Sawamura")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
tadashi_okabe = by_name.("Tadashi", "Okabe")
koji_uno = by_name.("Koji", "Uno")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
kenichiro_maruyama = by_name.("Kenichiro", "Maruyama")
yasuhiko_saijo = by_name.("Yasuhiko", "Saijo")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
wataru_omae = by_name.("Wataru", "Omae")
hideo_shibuya = by_name.("Hideo", "Shibuya")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
yoshio_katsube = by_name.("Yoshio", "Katsube")
somesho_matsumoto = by_name.("Somesho", "Matsumoto")
yutaka_oka = by_name.("Yutaka", "Oka")
yoshio_katsube = by_name.("Yoshio", "Katsube")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
akio_kusama = by_name.("Akio", "Kusama")
keisuke_yamada = by_name.("Keisuke", "Yamada")
keiji_sakakida = by_name.("Keiji", "Sakakida")
obel_wyatt = by_name.("Obel", "Wyatt")
ken_echigo = by_name.("Ken", "Echigo")
saburo_iketani = by_name.("Saburo", "Iketani")
osman_yusef = by_name.("Osman", "Yusef")

roles = [
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: ryo_ikebe.id,
    roles: ["Dr. Tazawa"],
    order: 1
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: yumi_shirakawa.id,
    roles: ["Tomoko Sonoda"],
    order: 2
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: akira_kubo.id,
    roles: ["Tatsuma Kanai"],
    order: 3
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: kumi_mizuno.id,
    roles: ["Takiko Nomura"],
    order: 4
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: hiroshi_tachikawa.id,
    roles: ["Astronaut Wakabayashi"],
    order: 5
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: akihiko_hirata.id,
    roles: ["Captain Endo"],
    order: 6
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: kenji_sahara.id,
    roles: ["Lt. Saiki"],
    order: 7
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: jun_tazaki.id,
    roles: ["Captain Raizo Sonoda"],
    order: 8
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: ken_uehara.id,
    roles: ["Dr. Kono"],
    order: 9
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: takashi_shimura.id,
    roles: ["Dr. Keisuke Sonoda"],
    order: 10
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: seizaburo_kawazu.id,
    roles: ["Minister Tada"],
    order: 11
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: ko_mishima.id,
    roles: ["South Pole Engineer Sanada"],
    order: 12
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: sachio_sakai.id,
    roles: ["Doctor"],
    order: 13
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: takamaru_sasaki.id,
    roles: ["Prime Minister Seki"],
    order: 14
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: ko_nishimura.id,
    roles: ["Minister Murata"],
    order: 15
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: eitaro_ozawa.id,
    roles: ["Minister Kinami"],
    order: 16
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: masanari_nihei.id,
    roles: ["Astronaut Ito"],
    order: 17
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: kozo_nomura.id,
    roles: ["Satellite Commander"],
    order: 18
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: keiko_sata.id,
    roles: ["Secretary"],
    order: 19
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: hideyo_amamoto.id,
    roles: ["Barfly"],
    order: 20
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: george_furness.id,
    roles: ["UN Ambassador"],
    order: 21
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: ross_bennett.id,
    roles: ["Gibson"],
    order: 22
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: junichiro_mukai.id,
    roles: ["Security Guard"],
    order: 23
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: nadao_kirino.id,
    roles: ["Lt. Manabe"],
    order: 24
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: fumio_sakashita.id,
    roles: ["Hayao Sonoda"],
    order: 25
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: ikio_sawamura.id,
    roles: ["Taxi Driver"],
    order: 26
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: rinsaku_ogata.id,
    roles: ["Spaceship Crew"],
    order: 29
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: tadashi_okabe.id,
    roles: ["Spaceship Crew"],
    order: 33
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: koji_uno.id,
    roles: ["Reporter"],
    order: 34
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: yukihiko_gondo.id,
    roles: ["Spaceship Crew"],
    order: 35
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: kenichiro_maruyama.id,
    roles: ["Spaceship Crew"],
    order: 36
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: yasuhiko_saijo.id,
    roles: ["Spaceship Crew"],
    order: 37
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: katsumi_tezuka.id,
    roles: ["Magma"],
    order: 38
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: wataru_omae.id,
    roles: ["Spaceship Crew"],
    order: 42
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 45
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: takuzo_kumagai.id,
    roles: ["Minister"],
    order: 50
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter", "Satellite Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: somesho_matsumoto.id,
    roles: ["Minister"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: yutaka_oka.id,
    roles: ["South Pole Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Minister"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: akio_kusama.id,
    roles: ["Minister"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: keisuke_yamada.id,
    roles: ["Minister"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: keiji_sakakida.id,
    roles: ["Minister"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: obel_wyatt.id,
    roles: ["UN Ambassador"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: ken_echigo.id,
    roles: ["Satellite Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: saburo_iketani.id,
    roles: ["TV Announcer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gorath.id,
    person_id: osman_yusef.id,
    roles: ["South Pole Crew"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^gorath.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
