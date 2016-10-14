alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

rodan = Repo.one from f in Film, where: f.title == "Rodan"

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
akio_kobori = by_name.("Akio", "Kobori")
akihiko_hirata = by_name.("Akihiko", "Hirata")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
minosuke_yamada = by_name.("Minosuke", "Yamada")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
fuminto_matsuo = by_name.("Fuminto", "Matsuo")
akio_kusama = by_name.("Akio", "Kusama")
hideo_mihara = by_name.("Hideo", "Mihara")
ren_imaizumi = by_name.("Ren", "Imaizumi")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
keiji_sakakida = by_name.("Keiji", "Sakakida")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
junichiro_mukai = by_name.("Junichiro", "Mukai")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
shoichi_hirose = by_name.("Shoichi", "Hirose")
koji_uno = by_name.("Koji", "Uno")
tadashi_okabe = by_name.("Tadashi", "Okabe")
yutaka_oka = by_name.("Yutaka", "Oka")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
hideo_shibuya = by_name.("Hideo", "Shibuya")
haruo_suzuki = by_name.("Haruo", "Suzuki")
ken_echigo = by_name.("Ken", "Echigo")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
ren_yamamoto = by_name.("Ren", "Yamamoto")
saburo_iketani = by_name.("Saburo", "Iketani")

roles = [
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: kenji_sahara.id,
    roles: ["Shigeru Kawamura"],
    order: 1
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: yumi_shirakawa.id,
    roles: ["Kiyo"],
    order: 2
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: akio_kobori.id,
    roles: ["Chief Nishimura"],
    order: 3
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: akihiko_hirata.id,
    roles: ["Dr. Kashiwagi"],
    order: 4
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: fuyuki_murakami.id,
    roles: ["Dr. Minami"],
    order: 5
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: minosuke_yamada.id,
    roles: ["Mining Chief Osaki"],
    order: 7
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Izeki"],
    order: 8
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: fuminto_matsuo.id,
    roles: ["Dr. Hayama"],
    order: 10
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: akio_kusama.id,
    roles: ["Tsuda"],
    order: 12
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: hideo_mihara.id,
    roles: ["Air Force Commander"],
    order: 15
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: ren_imaizumi.id,
    roles: ["Dr. Sunagawa"],
    order: 16
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: rinsaku_ogata.id,
    roles: ["Goro"],
    order: 20
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: keiji_sakakida.id,
    roles: ["Miner"],
    order: 21
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: takuzo_kumagai.id,
    roles: ["Policeman"],
    order: 22
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: junichiro_mukai.id,
    roles: ["Air Force Officer"],
    order: 24
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Air Force Officer"],
    order: 25
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: shoichi_hirose.id,
    roles: ["Meganulon", "Pilot"],
    order: 30
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: koji_uno.id,
    roles: ["Reporter"],
    order: 34
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: tadashi_okabe.id,
    roles: ["Reporter"],
    order: 35
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: yutaka_oka.id,
    roles: ["Pilot"],
    order: 36
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: masaaki_tachibana.id,
    roles: ["Policeman"],
    order: 41
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Pilot"],
    order: 45
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: haruya_sakamoto.id,
    roles: ["Miner"],
    order: 49
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Air Force Officer", "Police Chemist"],
    order: 51
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: hideo_shibuya.id,
    roles: ["Miner"],
    order: 54
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: haruo_suzuki.id,
    roles: ["Coal Car Staff"],
    order: 55
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: ken_echigo.id,
    roles: ["Policeman"],
    order: 58
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: katsumi_tezuka.id,
    roles: ["Meganulon", "Hotel Manager"],
    order: 61
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: haruo_nakajima.id,
    roles: ["Soldier", "Rodan"],
    order: 62
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: ren_yamamoto.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: rodan.id,
    person_id: saburo_iketani.id,
    roles: ["Newsreader"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^rodan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
