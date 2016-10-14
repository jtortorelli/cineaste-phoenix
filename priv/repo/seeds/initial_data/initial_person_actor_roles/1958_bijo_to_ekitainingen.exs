alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

h_man = Repo.one from f in Film, where: f.title == "The H-Man"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

yumi_shirakawa = by_name.("Yumi", "Shirakawa")
kenji_sahara = by_name.("Kenji", "Sahara")
akihiko_hirata = by_name.("Akihiko", "Hirata")
eitaro_ozawa = by_name.("Eitaro", "Ozawa")
koreya_senda = by_name.("Koreya", "Senda")
makoto_sato = by_name.("Makoto", "Sato")
hisaya_ito = by_name.("Hisaya", "Ito")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
ko_mishima = by_name.("Ko", "Mishima")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
tetsu_nakamura = by_name.("Tetsu", "Nakamura")
haruya_kato = by_name.("Haruya", "Kato")
senkichi_omura = by_name.("Senkichi", "Omura")
ayumi_sonoda = by_name.("Ayumi", "Sonoda")
kan_hayashi = by_name.("Kan", "Hayashi")
minosuke_yamada = by_name.("Minosuke", "Yamada")
jun_fujio = by_name.("Jun", "Fujio")
ren_yamamoto = by_name.("Ren", "Yamamoto")
akira_sera = by_name.("Akira", "Sera")
tadao_nakamaru = by_name.("Tadao", "Nakamaru")
yosuke_natsuki = by_name.("Yosuke", "Natsuki")
nadao_kirino = by_name.("Nadao", "Kirino")
yutaka_sada = by_name.("Yutaka", "Sada")
shin_otomo = by_name.("Shin", "Otomo")
soji_ubukata = by_name.("Soji", "Ubukata")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
shigeo_kato = by_name.("Shigeo", "Kato")
yutaka_oka = by_name.("Yutaka", "Oka")
shoichi_hirose = by_name.("Shoichi", "Hirose")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
akio_kusama = by_name.("Akio", "Kusama")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
hideo_shibuya = by_name.("Hideo", "Shibuya")
junichiro_mukai = by_name.("Junichiro", "Mukai")
haruo_suzuki = by_name.("Haruo", "Suzuki")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
yoshio_katsube = by_name.("Yoshio", "Katsube")
kazuo_hinata = by_name.("Kazuo", "Hinata")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")

roles = [
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yumi_shirakawa.id,
    roles: ["Chikako Arai"],
    order: 1
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: kenji_sahara.id,
    roles: ["Dr. Masada"],
    order: 2
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: akihiko_hirata.id,
    roles: ["Detective Tominaga"],
    order: 3
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: eitaro_ozawa.id,
    roles: ["Detective Miyashita"],
    order: 4
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: koreya_senda.id,
    roles: ["Dr. Maki"],
    order: 5
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: makoto_sato.id,
    roles: ["Uchida"],
    order: 6
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: hisaya_ito.id,
    roles: ["Misaki"],
    order: 7
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Detective Taguchi"],
    order: 9
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: ko_mishima.id,
    roles: ["Gangster"],
    order: 11
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Detective Sakata"],
    order: 12
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: tetsu_nakamura.id,
    roles: ["Mr. Chin"],
    order: 13
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: haruya_kato.id,
    roles: ["Fisherman"],
    order: 14
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: senkichi_omura.id,
    roles: ["Fisherman"],
    order: 15
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: ayumi_sonoda.id,
    roles: ["Nightclub Dancer"],
    order: 16
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: kan_hayashi.id,
    roles: ["Police Executive"],
    order: 17
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: minosuke_yamada.id,
    roles: ["Police Executive"],
    order: 18
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: jun_fujio.id,
    roles: ["Nishiyama"],
    order: 19
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: ren_yamamoto.id,
    roles: ["Gangster"],
    order: 20
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: akira_sera.id,
    roles: ["Fisherman"],
    order: 21
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: tadao_nakamaru.id,
    roles: ["Detective Seki"],
    order: 22
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yosuke_natsuki.id,
    roles: ["Bystander"],
    order: 23
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: nadao_kirino.id,
    roles: ["Gangster Waiter"],
    order: 27
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yutaka_sada.id,
    roles: ["Taxi Driver"],
    order: 28
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: shin_otomo.id,
    roles: ["Gangster"],
    order: 29
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: soji_ubukata.id,
    roles: ["Police Executive"],
    order: 30
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Police Executive"],
    order: 31
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yutaka_nakayama.id,
    roles: ["Informant Gangster"],
    order: 32
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Detective Ogawa"],
    order: 33
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: shigeo_kato.id,
    roles: ["Fisherman"],
    order: 34
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yutaka_oka.id,
    roles: ["Soldier"],
    order: 35
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: shoichi_hirose.id,
    roles: ["Fireman"],
    order: 36
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: takuzo_kumagai.id,
    roles: ["Soldier"],
    order: 37
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: akio_kusama.id,
    roles: ["Police Chemist"],
    order: 38
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Police Executive"],
    order: 39
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: katsumi_tezuka.id,
    roles: ["Fishing Captain"],
    order: 40
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: haruo_nakajima.id,
    roles: ["Fisherman"],
    order: 41
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: junichiro_mukai.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: haruo_suzuki.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: masaaki_tachibana.id,
    roles: ["Waiter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: kazuo_hinata.id,
    roles: ["Barfly", "Police Executive"],
    order: 99
  },
  %ActorPersonRole{
    film_id: h_man.id,
    person_id: yukihiko_gondo.id,
    roles: ["Policeman"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^h_man.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
