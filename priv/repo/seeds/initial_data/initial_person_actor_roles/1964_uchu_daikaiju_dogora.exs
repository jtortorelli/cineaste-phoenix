alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

dogora = Repo.one from f in Film, where: f.title == "Dogora, the Space Monster"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

yosuke_natsuki = by_name.("Yosuke", "Natsuki")
yoko_fujiyama = by_name.("Yoko", "Fujiyama")
hiroshi_koizumi = by_name.("Hiroshi", "Koizumi")
akiko_wakabayashi = by_name.("Akiko", "Wakabayashi")
nobuo_nakamura = by_name.("Nobuo", "Nakamura")
seizaburo_kawazu = by_name.("Seizaburo", "Kawazu")
robert_dunham = by_name.("Robert", "Dunham")
susumu_fujita = by_name.("Susumu", "Fujita")
jun_tazaki = by_name.("Jun", "Tazaki")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
nadao_kirino = by_name.("Nadao", "Kirino")
akira_wakamatsu = by_name.("Akira", "Wakamatsu")
haruya_kato = by_name.("Haruya", "Kato")
jun_funato = by_name.("Jun", "Funato")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
chotaro_togin = by_name.("Chotaro", "Togin")
shoichi_hirose = by_name.("Shoichi", "Hirose")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
hideo_shibuya = by_name.("Hideo", "Shibuya")
yutaka_oka = by_name.("Yutaka", "Oka")
tadashi_okabe = by_name.("Tadashi", "Okabe")
wataru_omae = by_name.("Wataru", "Omae")
koji_uno = by_name.("Koji", "Uno")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
haruo_suzuki = by_name.("Haruo", "Suzuki")
ken_echigo = by_name.("Ken", "Echigo")
keisuke_yamada = by_name.("Keisuke", "Yamada")
akio_kusama = by_name.("Akio", "Kusama")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
yoshio_katsube = by_name.("Yoshio", "Katsube")

roles = [
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yosuke_natsuki.id,
    roles: ["Detective Komai"],
    order: 1
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yoko_fujiyama.id,
    roles: ["Masayo Kirino"],
    order: 2
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: hiroshi_koizumi.id,
    roles: ["Dr. Kirino"],
    order: 3
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: akiko_wakabayashi.id,
    roles: ["Hamako"],
    order: 4
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: nobuo_nakamura.id,
    roles: ["Dr. Munakata"],
    order: 5
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: seizaburo_kawazu.id,
    roles: ["Gang Leader"],
    order: 6
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: robert_dunham.id,
    roles: ["Mark Jackson"],
    order: 7
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: susumu_fujita.id,
    roles: ["General Iwata"],
    order: 8
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: jun_tazaki.id,
    roles: ["Police Chief"],
    order: 9
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Gangster"],
    order: 10
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: hideyo_amamoto.id,
    roles: ["Gangster"],
    order: 11
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: nadao_kirino.id,
    roles: ["Gangster"],
    order: 12
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: akira_wakamatsu.id,
    roles: ["Gangster"],
    order: 13
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: haruya_kato.id,
    roles: ["Gangster"],
    order: 14
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: jun_funato.id,
    roles: ["Detective Nitta"],
    order: 15
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Policeman"],
    order: 16
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Soldier"],
    order: 18
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: takuzo_kumagai.id,
    roles: ["Military Advisor"],
    order: 19
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: chotaro_togin.id,
    roles: ["Truck Driver"],
    order: 20
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: shoichi_hirose.id,
    roles: ["Coal Miner"],
    order: 21
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yutaka_nakayama.id,
    roles: ["Coal Miner"],
    order: 22
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Coal Miner"],
    order: 24
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: haruya_sakamoto.id,
    roles: ["Truck Driver"],
    order: 26
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 27
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yutaka_oka.id,
    roles: ["Coal Miner"],
    order: 28
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: tadashi_okabe.id,
    roles: ["Policeman"],
    order: 32
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: wataru_omae.id,
    roles: ["Satellite Technician"],
    order: 33
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: koji_uno.id,
    roles: ["Coal Miner"],
    order: 34
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yukihiko_gondo.id,
    roles: ["Train Attendant"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Detective"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: haruo_suzuki.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: ken_echigo.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: keisuke_yamada.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: akio_kusama.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: masaaki_tachibana.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: rinsaku_ogata.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: dogora.id,
    person_id: yoshio_katsube.id,
    roles: ["Satellite Technician"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^dogora.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
