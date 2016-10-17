alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

mothra = Repo.one from f in Film, where: f.title == "Mothra"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

frankie_sakai = by_name.("Frankie", "Sakai")
hiroshi_koizumi = by_name.("Hiroshi", "Koizumi")
kyoko_kagawa = by_name.("Kyoko", "Kagawa")
jerry_ito = by_name.("Jerry", "Ito")
ken_uehara = by_name.("Ken", "Uehara")
akihiko_hirata = by_name.("Akihiko", "Hirata")
kenji_sahara = by_name.("Kenji", "Sahara")
seizaburo_kawazu = by_name.("Seizaburo", "Kawazu")
takashi_shimura = by_name.("Takashi", "Shimura")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
ren_yamamoto = by_name.("Ren", "Yamamoto")
haruya_kato = by_name.("Haruya", "Kato")
tetsu_nakamura = by_name.("Tetsu", "Nakamura")
shoichi_hirose = by_name.("Shoichi", "Hirose")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
tadashi_okabe = by_name.("Tadashi", "Okabe")
akira_wakamatsu = by_name.("Akira", "Wakamatsu")
osman_yusef = by_name.("Osman", "Yusef")
obel_wyatt = by_name.("Obel", "Wyatt")
harold_conway = by_name.("Harold", "Conway")
robert_dunham = by_name.("Robert", "Dunham")
koji_uno = by_name.("Koji", "Uno")
wataru_omae = by_name.("Wataru", "Omae")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
hideo_shibuya = by_name.("Hideo", "Shibuya")
kazuo_hinata = by_name.("Kazuo", "Hinata")
shigeo_kato = by_name.("Shigeo", "Kato")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
yutaka_oka = by_name.("Yutaka", "Oka")
yoshio_katsube = by_name.("Yoshio", "Katsube")
akio_kusama = by_name.("Akio", "Kusama")
haruo_nakajima = by_name.("Haruo", "Nakajima")
junpei_natsuki = by_name.("Junpei", "Natsuki")
hiroshi_sekida = by_name.("Hiroshi", "Sekida")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
keiji_sakakida = by_name.("Keiji", "Sakakida")
masanari_nihei = by_name.("Masanari", "Nihei")
minoru_ito = by_name.("Minoru", "Ito")
saburo_iketani = by_name.("Saburo", "Iketani")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")

roles = [
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: frankie_sakai.id,
    roles: ["Senichiro Fukuda"],
    order: 1
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: hiroshi_koizumi.id,
    roles: ["Dr. Shinichi Chujo"],
    order: 2
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: kyoko_kagawa.id,
    roles: ["Michi Hanamura"],
    order: 3
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: jerry_ito.id,
    roles: ["Clark Nelson"],
    order: 5
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: ken_uehara.id,
    roles: ["Dr. Harada"],
    order: 6
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: akihiko_hirata.id,
    roles: ["Doctor"],
    order: 7
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: kenji_sahara.id,
    roles: ["Helicopter Pilot"],
    order: 8
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: seizaburo_kawazu.id,
    roles: ["General"],
    order: 9
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: takashi_shimura.id,
    roles: ["Newspaper Editor"],
    order: 10
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: yoshio_kosugi.id,
    roles: ["Ship's Captain"],
    order: 11
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Soldier"],
    order: 12
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: ren_yamamoto.id,
    roles: ["Marooned Sailor"],
    order: 13
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: haruya_kato.id,
    roles: ["Marooned Sailor"],
    order: 14
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: tetsu_nakamura.id,
    roles: ["Nelson's Henchman"],
    order: 16
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: shoichi_hirose.id,
    roles: ["Dam Worker"],
    order: 17
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Expedition Member"],
    order: 20
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Cruise Ship Captain"],
    order: 23
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: tadashi_okabe.id,
    roles: ["Expedition Member"],
    order: 26
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: akira_wakamatsu.id,
    roles: ["Nelson's Henchman"],
    order: 27
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: osman_yusef.id,
    roles: ["Nelson's Henchman"],
    order: 29
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: obel_wyatt.id,
    roles: ["Rolisican Mayor"],
    order: 30
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: harold_conway.id,
    roles: ["Rolisican Ambassador"],
    order: 31
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: robert_dunham.id,
    roles: ["Rolisican Policeman"],
    order: 32
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: koji_uno.id,
    roles: ["Policeman"],
    order: 34
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: wataru_omae.id,
    roles: ["Coast Guard"],
    order: 35
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: katsumi_tezuka.id,
    roles: ["Mothra"],
    order: 39
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 42
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: kazuo_hinata.id,
    roles: ["Military Officer"],
    order: 43
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: shigeo_kato.id,
    roles: ["Dam Worker"],
    order: 44
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: rinsaku_ogata.id,
    roles: ["Fighter Pilot"],
    order: 45
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: yutaka_oka.id,
    roles: ["Pilot"],
    order: 46
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: yoshio_katsube.id,
    roles: ["Expedition Member"],
    order: 50
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: akio_kusama.id,
    roles: ["Soldier"],
    order: 52
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: haruo_nakajima.id,
    roles: ["Mothra"],
    order: 53
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: junpei_natsuki.id,
    roles: ["Evacuee"],
    order: 56
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: hiroshi_sekida.id,
    roles: ["Cruise Liner Helmsman"],
    order: 59
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: masaaki_tachibana.id,
    roles: ["Reporter"],
    order: 61
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: haruya_sakamoto.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: keiji_sakakida.id,
    roles: ["Doctor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: masanari_nihei.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: minoru_ito.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: saburo_iketani.id,
    roles: ["Announcer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mothra.id,
    person_id: yukihiko_gondo.id,
    roles: ["Dam Worker"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^mothra.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
