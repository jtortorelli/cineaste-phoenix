alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

atragon = Repo.one from f in Film, where: f.title == "Atragon"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

tadao_takashima = by_name.("Tadao", "Takashima")
yoko_fujiyama = by_name.("Yoko", "Fujiyama")
yu_fujiki = by_name.("Yu", "Fujiki")
kenji_sahara = by_name.("Kenji", "Sahara")
ken_uehara = by_name.("Ken", "Uehara")
hiroshi_koizumi = by_name.("Hiroshi", "Koizumi")
jun_tazaki = by_name.("Jun", "Tazaki")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
akihiko_hirata = by_name.("Akihiko", "Hirata")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
susumu_fujita = by_name.("Susumu", "Fujita")
minoru_takada = by_name.("Minoru", "Takada")
hisaya_ito = by_name.("Hisaya", "Ito")
ikio_sawamura = by_name.("Ikio", "Sawamura")
tetsuko_kobayashi = by_name.("Tetsuko", "Kobayashi")
hiroshi_hasegawa = by_name.("Hiroshi", "Hasegawa")
nadao_kirino = by_name.("Nadao", "Kirino")
shin_otomo = by_name.("Shin", "Otomo")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
tetsu_nakamura = by_name.("Tetsu", "Nakamura")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
koji_uno = by_name.("Koji", "Uno")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
yutaka_oka = by_name.("Yutaka", "Oka")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
shoichi_hirose = by_name.("Shoichi", "Hirose")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
wataru_omae = by_name.("Wataru", "Omae")
hideo_shibuya = by_name.("Hideo", "Shibuya")
keisuke_yamada = by_name.("Keisuke", "Yamada")
tadashi_okabe = by_name.("Tadashi", "Okabe")
yoshio_katsube = by_name.("Yoshio", "Katsube")
haruo_suzuki = by_name.("Haruo", "Suzuki")
osman_yusef = by_name.("Osman", "Yusef")

roles = [
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: tadao_takashima.id,
    roles: ["Susumu Hatanaka"],
    order: 1
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: yoko_fujiyama.id,
    roles: ["Makoto Jinguji"],
    order: 2
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: yu_fujiki.id,
    roles: ["Yoshito Nishibe"],
    order: 3
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: kenji_sahara.id,
    roles: ["Unno"],
    order: 4
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: ken_uehara.id,
    roles: ["Admiral Kusumi"],
    order: 5
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: hiroshi_koizumi.id,
    roles: ["Detective Ito"],
    order: 6
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: jun_tazaki.id,
    roles: ["Captain Hachiro Jinguji"],
    order: 7
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Lt. Amano"],
    order: 8
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: akihiko_hirata.id,
    roles: ["Mu Agent No. 23"],
    order: 9
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: hideyo_amamoto.id,
    roles: ["High Priest of Mu"],
    order: 10
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: susumu_fujita.id,
    roles: ["General"],
    order: 11
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: minoru_takada.id,
    roles: ["Military Officer"],
    order: 12
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: hisaya_ito.id,
    roles: ["Kidnapped Scientist"],
    order: 13
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: ikio_sawamura.id,
    roles: ["Taxi Driver"],
    order: 14
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: tetsuko_kobayashi.id,
    roles: ["Empress of Mu"],
    order: 15
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: hiroshi_hasegawa.id,
    roles: ["Atragon Crew"],
    order: 16
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: nadao_kirino.id,
    roles: ["Kidnapped Scientist"],
    order: 17
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: shin_otomo.id,
    roles: ["Military Officer"],
    order: 18
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: haruya_sakamoto.id,
    roles: ["Atragon Crew"],
    order: 19
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: tetsu_nakamura.id,
    roles: ["Cargo Ship Captain"],
    order: 20
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: yutaka_nakayama.id,
    roles: ["Cargo Ship Crew"],
    order: 21
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Military Officer"],
    order: 22
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: koji_uno.id,
    roles: ["Policeman"],
    order: 23
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: rinsaku_ogata.id,
    roles: ["Military Officer"],
    order: 25
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: yutaka_oka.id,
    roles: ["Mihara Tourist"],
    order: 27
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: yukihiko_gondo.id,
    roles: ["Mihara Tourist"],
    order: 28
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: shoichi_hirose.id,
    roles: ["Mu Citizen"],
    order: 29
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: katsumi_tezuka.id,
    roles: ["Military Officer"],
    order: 30
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: takuzo_kumagai.id,
    roles: ["Military Officer"],
    order: 31
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Atragon Crew"],
    order: 33
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: wataru_omae.id,
    roles: ["Soldier"],
    order: 34
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: hideo_shibuya.id,
    roles: ["Soldier"],
    order: 38
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: keisuke_yamada.id,
    roles: ["Military Officer"],
    order: 39
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: tadashi_okabe.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: yoshio_katsube.id,
    roles: ["Atragon Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: haruo_suzuki.id,
    roles: ["Atragon Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: atragon.id,
    person_id: osman_yusef.id,
    roles: ["Mu Soldier"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^atragon.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
