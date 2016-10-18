alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

samurai_pirate = Repo.one from f in Film, where: f.title == "Samurai Pirate"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

toshiro_mifune = by_name.("Toshiro", "Mifune")
makoto_sato = by_name.("Makoto", "Sato")
ichiro_arishima = by_name.("Ichiro", "Arishima")
mitsuko_kusabue = by_name.("Mitsuko", "Kusabue")
mie_hama = by_name.("Mie", "Hama")
akiko_wakabayashi = by_name.("Akiko", "Wakabayashi")
kumi_mizuno = by_name.("Kumi", "Mizuno")
tadao_nakamaru = by_name.("Tadao", "Nakamaru")
jun_tazaki = by_name.("Jun", "Tazaki")
jun_funato = by_name.("Jun", "Funato")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
takashi_shimura = by_name.("Takashi", "Shimura")
hideo_sunazuka = by_name.("Hideo", "Sunazuka")
masanari_nihei = by_name.("Masanari", "Nihei")
shoji_oki = by_name.("Shoji", "Oki")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
nakajiro_tomita = by_name.("Nakajiro", "Tomita")
tetsu_nakamura = by_name.("Tetsu", "Nakamura")
nadao_kirino = by_name.("Nadao", "Kirino")
junichiro_mukai = by_name.("Junichiro", "Mukai")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
hiroshi_hasegawa = by_name.("Hiroshi", "Hasegawa")
eishu_kin = by_name.("Eishu", "Kin")
haruo_suzuki = by_name.("Haruo", "Suzuki")
seishiro_kuno = by_name.("Seishiro", "Kuno")
akio_kusama = by_name.("Akio", "Kusama")
keiji_sakakida = by_name.("Keiji", "Sakakida")
yutaka_oka = by_name.("Yutaka", "Oka")

roles = [
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: toshiro_mifune.id,
    roles: ["Sukeza"],
    order: 1
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: makoto_sato.id,
    roles: ["The Black Pirate"],
    order: 2
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: ichiro_arishima.id,
    roles: ["The Wizard of Kume"],
    order: 3
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: mitsuko_kusabue.id,
    roles: ["Sobei"],
    order: 4
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: mie_hama.id,
    roles: ["Princess Yaya"],
    order: 5
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: akiko_wakabayashi.id,
    roles: ["Yaya's Handmaiden"],
    order: 6
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: kumi_mizuno.id,
    roles: ["Miwa, the Rebel Leader"],
    order: 7
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: tadao_nakamaru.id,
    roles: ["The Chancellor"],
    order: 8
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: jun_tazaki.id,
    roles: ["Slim"],
    order: 9
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: jun_funato.id,
    roles: ["The Prince of Ming"],
    order: 10
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: hideyo_amamoto.id,
    roles: ["Granny the Witch"],
    order: 11
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: takashi_shimura.id,
    roles: ["King Rasetsu"],
    order: 12
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: hideo_sunazuka.id,
    roles: ["Mustachioed Rebel"],
    order: 13
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: masanari_nihei.id,
    roles: ["Tall Rebel"],
    order: 14
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: shoji_oki.id,
    roles: ["Turbaned Rebel"],
    order: 15
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: yutaka_nakayama.id,
    roles: ["Samurai Ichizo"],
    order: 16
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: yoshio_kosugi.id,
    roles: ["Ming Advisor"],
    order: 17
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: nakajiro_tomita.id,
    roles: ["Samurai Tokubei"],
    order: 18
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: tetsu_nakamura.id,
    roles: ["Archer"],
    order: 19
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: nadao_kirino.id,
    roles: ["Samurai"],
    order: 20
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: junichiro_mukai.id,
    roles: ["Jail Keeper"],
    order: 22
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Samurai"],
    order: 23
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: hiroshi_hasegawa.id,
    roles: ["Palace Guard"],
    order: 25
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: eishu_kin.id,
    roles: ["Giant Bodyguard"],
    order: 26
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: haruo_suzuki.id,
    roles: ["Samurai"],
    order: 27
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: seishiro_kuno.id,
    roles: ["Prison Guard"],
    order: 99
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: akio_kusama.id,
    roles: ["Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: keiji_sakakida.id,
    roles: ["Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: samurai_pirate.id,
    person_id: yutaka_oka.id,
    roles: ["Pirate"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^samurai_pirate.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
