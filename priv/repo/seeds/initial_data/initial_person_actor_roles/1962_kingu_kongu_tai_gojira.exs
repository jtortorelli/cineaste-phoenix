alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

kkvg = Repo.one from f in Film, where: f.title == "King Kong vs. Godzilla"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

tadao_takashima = by_name.("Tadao", "Takashima")
kenji_sahara = by_name.("Kenji", "Sahara")
yu_fujiki = by_name.("Yu", "Fujiki")
ichiro_arishima = by_name.("Ichiro", "Arishima")
jun_tazaki = by_name.("Jun", "Tazaki")
akihiko_hirata = by_name.("Akihiko", "Hirata")
mie_hama = by_name.("Mie", "Hama")
akiko_wakabayashi = by_name.("Akiko", "Wakabayashi")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
ikio_sawamura = by_name.("Ikio", "Sawamura")
somesho_matsumoto = by_name.("Somesho", "Matsumoto")
ko_mishima = by_name.("Ko", "Mishima")
sachio_sakai = by_name.("Sachio", "Sakai")
tatsuo_matsumura = by_name.("Tatsuo", "Matsumura")
senkichi_omura = by_name.("Senkichi", "Omura")
ren_yamamoto = by_name.("Ren", "Yamamoto")
haruya_kato = by_name.("Haruya", "Kato")
shin_otomo = by_name.("Shin", "Otomo")
nadao_kirino = by_name.("Nadao", "Kirino")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
naoya_kusakawa = by_name.("Naoya", "Kusakawa")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
kenzo_tabu = by_name.("Kenzo", "Tabu")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
kazuo_suzuki = by_name.("Kazuo", "Suzuki")
hideo_shibuya = by_name.("Hideo", "Shibuya")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
douglas_fein = by_name.("Douglas", "Fein")
harold_conway = by_name.("Harold", "Conway")
osman_yusef = by_name.("Osman", "Yusef")
shoichi_hirose = by_name.("Shoichi", "Hirose")
haruo_nakajima = by_name.("Haruo", "Nakajima")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
keisuke_yamada = by_name.("Keisuke", "Yamada")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
tadashi_okabe = by_name.("Tadashi", "Okabe")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
haruo_suzuki = by_name.("Haruo", "Suzuki")
akio_kusama = by_name.("Akio", "Kusama")
kazuo_hinata = by_name.("Kazuo", "Hinata")
junpei_natsuki = by_name.("Junpei", "Natsuki")

roles = [
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: tadao_takashima.id,
    roles: ["Osamu Sakurai"],
    order: 1
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: kenji_sahara.id,
    roles: ["Kazuo Fujita"],
    order: 2
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: yu_fujiki.id,
    roles: ["Kinsaburo Furue"],
    order: 3
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: ichiro_arishima.id,
    roles: ["Mr. Tako"],
    order: 4
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: jun_tazaki.id,
    roles: ["General Shinzo"],
    order: 5
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: akihiko_hirata.id,
    roles: ["Minister Shigezawa"],
    order: 6
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: mie_hama.id,
    roles: ["Fumiko Sakurai"],
    order: 7
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: akiko_wakabayashi.id,
    roles: ["Tamiye"],
    order: 8
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: yoshio_kosugi.id,
    roles: ["Faro Island Chief"],
    order: 10
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Research Ship Captain"],
    order: 11
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: ikio_sawamura.id,
    roles: ["Island Priest"],
    order: 12
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: somesho_matsumoto.id,
    roles: ["Dr. Onuki"],
    order: 13
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: ko_mishima.id,
    roles: ["Coast Guard"],
    order: 14
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: sachio_sakai.id,
    roles: ["Obayashi"],
    order: 15
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: tatsuo_matsumura.id,
    roles: ["Dr. Makino"],
    order: 16
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: senkichi_omura.id,
    roles: ["Guide"],
    order: 17
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: ren_yamamoto.id,
    roles: ["Soldier"],
    order: 18
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: haruya_kato.id,
    roles: ["Obayashi's Assistant"],
    order: 19
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: shin_otomo.id,
    roles: ["Transport Ship Captain"],
    order: 20
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: nadao_kirino.id,
    roles: ["Soldier"],
    order: 21
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Soldier"],
    order: 22
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: yutaka_nakayama.id,
    roles: ["Sailor"],
    order: 23
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: naoya_kusakawa.id,
    roles: ["Reporter"],
    order: 25
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Military Official"],
    order: 26
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: kenzo_tabu.id,
    roles: ["TV Host"],
    order: 28
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: takuzo_kumagai.id,
    roles: ["Military Official"],
    order: 29
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Evacuee"],
    order: 30
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: kazuo_suzuki.id,
    roles: ["Bystander"],
    order: 32
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 33
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: masaaki_tachibana.id,
    roles: ["Reporter"],
    order: 34
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: haruya_sakamoto.id,
    roles: ["Soldier"],
    order: 35
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: douglas_fein.id,
    roles: ["Submarine Captain"],
    order: 41
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: harold_conway.id,
    roles: ["Scientist"],
    order: 42
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: osman_yusef.id,
    roles: ["Scientist"],
    order: 43
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: shoichi_hirose.id,
    roles: ["King Kong"],
    order: 44
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla"],
    order: 45
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: katsumi_tezuka.id,
    roles: ["Godzilla"],
    order: 46
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: keisuke_yamada.id,
    roles: ["Military Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: rinsaku_ogata.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: tadashi_okabe.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: yukihiko_gondo.id,
    roles: ["Helicopter Pilot"],
    order: 99
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: haruo_suzuki.id,
    roles: ["Sailor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: akio_kusama.id,
    roles: ["Military Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: kazuo_hinata.id,
    roles: ["Scientist"],
    order: 99
  },
  %ActorPersonRole{
    film_id: kkvg.id,
    person_id: junpei_natsuki.id,
    roles: ["Islander"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^kkvg.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
