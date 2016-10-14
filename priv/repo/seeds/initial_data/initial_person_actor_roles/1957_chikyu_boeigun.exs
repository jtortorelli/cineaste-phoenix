alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

mysterians = Repo.one from f in Film, where: f.title == "The Mysterians"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

kenji_sahara = by_name.("Kenji", "Sahara")
yumi_shirakawa = by_name.("Yumi", "Shirakawa")
momoko_kochi = by_name.("Momoko", "Kochi")
akihiko_hirata = by_name.("Akihiko", "Hirata")
takashi_shimura = by_name.("Takashi", "Shimura")
susumu_fujita = by_name.("Susumu", "Fujita")
hisaya_ito = by_name.("Hisaya", "Ito")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
minosuke_yamada = by_name.("Minosuke", "Yamada")
tetsu_nakamura = by_name.("Tetsu", "Nakamura")
heihachiro_okawa = by_name.("Heihachiro", "Okawa")
takeo_oikawa = by_name.("Takeo", "Oikawa")
haruya_kato = by_name.("Haruya", "Kato")
senkichi_omura = by_name.("Senkichi", "Omura")
yutaka_sada = by_name.("Yutaka", "Sada")
hideo_mihara = by_name.("Hideo", "Mihara")
soji_ubukata = by_name.("Soji", "Ubukata")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
ren_imaizumi = by_name.("Ren", "Imaizumi")
shin_otomo = by_name.("Shin", "Otomo")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
akio_kusama = by_name.("Akio", "Kusama")
shoichi_hirose = by_name.("Shoichi", "Hirose")
tadao_nakamaru = by_name.("Tadao", "Nakamaru")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
george_furness = by_name.("George", "Furness")
harold_conway = by_name.("Harold", "Conway")
haruo_nakajima = by_name.("Haruo", "Nakajima")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
yoshio_katsube = by_name.("Yoshio", "Katsube")
tadashi_okabe = by_name.("Tadashi", "Okabe")
minoru_ito = by_name.("Minoru", "Ito")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
keiji_sakakida = by_name.("Keiji", "Sakakida")
kazuo_hinata = by_name.("Kazuo", "Hinata")
hideo_shibuya = by_name.("Hideo", "Shibuya")
junichiro_mukai = by_name.("Junichiro", "Mukai")

roles = [
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: kenji_sahara.id,
    roles: ["Dr. Joji Atsumi"],
    order: 1
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: yumi_shirakawa.id,
    roles: ["Etsuko Shiraishi"],
    order: 2
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: momoko_kochi.id,
    roles: ["Hiroko Iwamoto"],
    order: 3
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: akihiko_hirata.id,
    roles: ["Dr. Ryoichi Shiraishi"],
    order: 4
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: takashi_shimura.id,
    roles: ["Dr. Tanjiro Adachi"],
    order: 5
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: susumu_fujita.id,
    roles: ["General Morita"],
    order: 6
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: hisaya_ito.id,
    roles: ["Officer Seki"],
    order: 7
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: yoshio_kosugi.id,
    roles: ["Officer Sugimoto"],
    order: 8
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: fuyuki_murakami.id,
    roles: ["Dr. Kawanami"],
    order: 9
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["The Grand Mysterian"],
    order: 10
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: minosuke_yamada.id,
    roles: ["Defense Secretary"],
    order: 11
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: tetsu_nakamura.id,
    roles: ["Dr. Koda"],
    order: 12
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: heihachiro_okawa.id,
    roles: ["Translator"],
    order: 13
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: takeo_oikawa.id,
    roles: ["Newsreader"],
    order: 14
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: haruya_kato.id,
    roles: ["Villager"],
    order: 15
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: senkichi_omura.id,
    roles: ["Villager"],
    order: 16
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: yutaka_sada.id,
    roles: ["Policeman"],
    order: 17
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: hideo_mihara.id,
    roles: ["Military Officer"],
    order: 18
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: soji_ubukata.id,
    roles: ["Dr. Noda"],
    order: 19
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Parliamentarian"],
    order: 20
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: ren_imaizumi.id,
    roles: ["Adachi's Assistant"],
    order: 21
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: shin_otomo.id,
    roles: ["Policeman"],
    order: 22
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: takuzo_kumagai.id,
    roles: ["Soldier"],
    order: 23
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: akio_kusama.id,
    roles: ["Policeman"],
    order: 24
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: shoichi_hirose.id,
    roles: ["Detective"],
    order: 25
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: tadao_nakamaru.id,
    roles: ["Soldier"],
    order: 26
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Policeman"],
    order: 27
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: rinsaku_ogata.id,
    roles: ["Policeman"],
    order: 28
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: george_furness.id,
    roles: ["Dr. Svenson"],
    order: 30
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: harold_conway.id,
    roles: ["Dr. DeGracia"],
    order: 31
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: haruo_nakajima.id,
    roles: ["Mogera", "Soldier"],
    order: 32
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: katsumi_tezuka.id,
    roles: ["Mogera"],
    order: 33
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: tadashi_okabe.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: minoru_ito.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: masaaki_tachibana.id,
    roles: ["Soldier", "Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: keiji_sakakida.id,
    roles: ["Military Officer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: kazuo_hinata.id,
    roles: ["Pilot"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: hideo_shibuya.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mysterians.id,
    person_id: junichiro_mukai.id,
    roles: ["Pilot"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^mysterians.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
