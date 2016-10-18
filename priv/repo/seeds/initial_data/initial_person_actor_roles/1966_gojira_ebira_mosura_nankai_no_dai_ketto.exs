alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

sea_monster = Repo.one from f in Film, where: f.title == "Godzilla vs. the Sea Monster"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

akira_takarada = by_name.("Akira", "Takarada")
kumi_mizuno = by_name.("Kumi", "Mizuno")
akihiko_hirata = by_name.("Akihiko", "Hirata")
jun_tazaki = by_name.("Jun", "Tazaki")
hideo_sunazuka = by_name.("Hideo", "Sunazuka")
chotaro_togin = by_name.("Chotaro", "Togin")
toru_ibuki = by_name.("Toru", "Ibuki")
toru_watanabe = by_name.("Toru", "Watanabe")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
ikio_sawamura = by_name.("Ikio", "Sawamura")
hisaya_ito = by_name.("Hisaya", "Ito")
shigeki_ishida = by_name.("Shigeki", "Ishida")
shoichi_hirose = by_name.("Shoichi", "Hirose")
kazuo_suzuki = by_name.("Kazuo", "Suzuki")
yutaka_sada = by_name.("Yutaka", "Sada")
chieko_nakakita = by_name.("Chieko", "Nakakita")
tadashi_okabe = by_name.("Tadashi", "Okabe")
wataru_omae = by_name.("Wataru", "Omae")
kenichiro_maruyama = by_name.("Kenichiro", "Maruyama")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
yoshio_katsube = by_name.("Yoshio", "Katsube")
hideo_shibuya = by_name.("Hideo", "Shibuya")
haruo_nakajima = by_name.("Haruo", "Nakajima")
hiroshi_sekida = by_name.("Hiroshi", "Sekida")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
junpei_natsuki = by_name.("Junpei", "Natsuki")


roles = [
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: akira_takarada.id,
    roles: ["Yoshimura"],
    order: 1
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: kumi_mizuno.id,
    roles: ["Daiyo"],
    order: 2
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: akihiko_hirata.id,
    roles: ["Red Bamboo Captain Yamoto"],
    order: 3
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: jun_tazaki.id,
    roles: ["Red Bamboo Commander"],
    order: 4
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: hideo_sunazuka.id,
    roles: ["Nita"],
    order: 5
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: chotaro_togin.id,
    roles: ["Ichino"],
    order: 6
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: toru_ibuki.id,
    roles: ["Yata"],
    order: 7
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: toru_watanabe.id,
    roles: ["Ryota"],
    order: 8
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: hideyo_amamoto.id,
    roles: ["Red Bamboo Officer"],
    order: 9
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: ikio_sawamura.id,
    roles: ["Captive Islander"],
    order: 10
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: hisaya_ito.id,
    roles: ["Red Bamboo Scientist"],
    order: 11
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: shigeki_ishida.id,
    roles: ["Newspaper Editor"],
    order: 12
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: shoichi_hirose.id,
    roles: ["Escaped Islander"],
    order: 13
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: kazuo_suzuki.id,
    roles: ["Escaped Islander"],
    order: 14
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: yutaka_sada.id,
    roles: ["Villager"],
    order: 15
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: chieko_nakakita.id,
    roles: ["Yata's & Ryota's Mother"],
    order: 17
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: tadashi_okabe.id,
    roles: ["Red Bamboo Scientist"],
    order: 19
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: wataru_omae.id,
    roles: ["Reporter"],
    order: 20
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: kenichiro_maruyama.id,
    roles: ["Reporter"],
    order: 21
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: rinsaku_ogata.id,
    roles: ["Red Bamboo Soldier"],
    order: 22
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: yoshio_katsube.id,
    roles: ["Captive Islander", "Red Bamboo Soldier"],
    order: 23
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: hideo_shibuya.id,
    roles: ["Policeman"],
    order: 24
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla"],
    order: 25
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: hiroshi_sekida.id,
    roles: ["Ebirah"],
    order: 26
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: yukihiko_gondo.id,
    roles: ["Red Bamboo Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: sea_monster.id,
    person_id: junpei_natsuki.id,
    roles: ["Captive Islander"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^sea_monster.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
