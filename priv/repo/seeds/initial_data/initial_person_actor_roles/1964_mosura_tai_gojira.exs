alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

mvg = Repo.one from f in Film, where: f.title == "Mothra vs. Godzilla"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

akira_takarada = by_name.("Akira", "Takarada")
yuriko_hoshi = by_name.("Yuriko", "Hoshi")
hiroshi_koizumi = by_name.("Hiroshi", "Koizumi")
yu_fujiki = by_name.("Yu", "Fujiki")
kenji_sahara = by_name.("Kenji", "Sahara")
jun_tazaki = by_name.("Jun", "Tazaki")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
kenzo_tabu = by_name.("Kenzo", "Tabu")
yutaka_sada = by_name.("Yutaka", "Sada")
akira_tani = by_name.("Akira", "Tani")
susumu_fujita = by_name.("Susumu", "Fujita")
ikio_sawamura = by_name.("Ikio", "Sawamura")
ren_yamamoto = by_name.("Ren", "Yamamoto")
kozo_nomura = by_name.("Kozo", "Nomura")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
shin_otomo = by_name.("Shin", "Otomo")
senkichi_omura = by_name.("Senkichi", "Omura")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
miki_yashiro = by_name.("Miki", "Yashiro")
wataru_omae = by_name.("Wataru", "Omae")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
koji_uno = by_name.("Koji", "Uno")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
hideo_shibuya = by_name.("Hideo", "Shibuya")
ken_echigo = by_name.("Ken", "Echigo")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
tadashi_okabe = by_name.("Tadashi", "Okabe")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
seishiro_kuno = by_name.("Seishiro", "Kuno")
keisuke_yamada = by_name.("Keisuke", "Yamada")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
haruo_suzuki = by_name.("Haruo", "Suzuki")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
harold_conway = by_name.("Harold", "Conway")
osman_yusef = by_name.("Osman", "Yusef")
yutaka_oka = by_name.("Yutaka", "Oka")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
kenichiro_maruyama = by_name.("Kenichiro", "Maruyama")
keiji_sakakida = by_name.("Keiji", "Sakakida")
kazuo_hinata = by_name.("Kazuo", "Hinata")
junpei_natsuki = by_name.("Junpei", "Natsuki")
yoshio_katsube = by_name.("Yoshio", "Katsube")

roles = [
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: akira_takarada.id,
    roles: ["Ichiro Sakai"],
    order: 1
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yuriko_hoshi.id,
    roles: ["Junko Nakanishi"],
    order: 2
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: hiroshi_koizumi.id,
    roles: ["Dr. Miura"],
    order: 3
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yu_fujiki.id,
    roles: ["Jiro Nakamura"],
    order: 4
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: kenji_sahara.id,
    roles: ["Torahata"],
    order: 5
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: jun_tazaki.id,
    roles: ["Newspaper Editor"],
    order: 7
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Kumayama"],
    order: 8
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: kenzo_tabu.id,
    roles: ["Industrial Park Developer"],
    order: 9
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yutaka_sada.id,
    roles: ["School Principal"],
    order: 10
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: akira_tani.id,
    roles: ["Chief Fisherman"],
    order: 11
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: susumu_fujita.id,
    roles: ["General"],
    order: 12
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: ikio_sawamura.id,
    roles: ["Village Priest"],
    order: 13
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: ren_yamamoto.id,
    roles: ["Sailor"],
    order: 14
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: kozo_nomura.id,
    roles: ["Soldier"],
    order: 15
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Village Policeman"],
    order: 16
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Soldier"],
    order: 17
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: shin_otomo.id,
    roles: ["Policeman"],
    order: 18
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: senkichi_omura.id,
    roles: ["Fisherman"],
    order: 19
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yoshio_kosugi.id,
    roles: ["Infant Island Chief"],
    order: 20
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: miki_yashiro.id,
    roles: ["Schoolteacher"],
    order: 21
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: wataru_omae.id,
    roles: ["Kumayama's Henchman"],
    order: 24
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Fisherman"],
    order: 25
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: takuzo_kumagai.id,
    roles: ["Fisherman"],
    order: 26
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: koji_uno.id,
    roles: ["Fisherman"],
    order: 27
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yutaka_nakayama.id,
    roles: ["Fisherman"],
    order: 28
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 30
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: ken_echigo.id,
    roles: ["Reporter"],
    order: 32
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yukihiko_gondo.id,
    roles: ["Kumayama's Henchman"],
    order: 33
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: tadashi_okabe.id,
    roles: ["Soldier"],
    order: 36
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: haruya_sakamoto.id,
    roles: ["Soldier"],
    order: 37
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: seishiro_kuno.id,
    roles: ["Soldier"],
    order: 38
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: keisuke_yamada.id,
    roles: ["Policeman"],
    order: 40
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: rinsaku_ogata.id,
    roles: ["Islander"],
    order: 44
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: haruo_suzuki.id,
    roles: ["Radio Operator"],
    order: 45
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: katsumi_tezuka.id,
    roles: ["Godzilla"],
    order: 47
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla"],
    order: 48
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: harold_conway.id,
    roles: ["Military Advisor (American Version)"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: osman_yusef.id,
    roles: ["Reporter (American Version)"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yutaka_oka.id,
    roles: ["Hotel Clerk"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: masaaki_tachibana.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: kenichiro_maruyama.id,
    roles: ["Islander"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: keiji_sakakida.id,
    roles: ["Islander"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: kazuo_hinata.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: junpei_natsuki.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: mvg.id,
    person_id: yoshio_katsube.id,
    roles: ["Fisherman"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^mvg.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
