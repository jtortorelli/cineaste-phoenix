alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

gargantuas = Repo.one from f in Film, where: f.title == "War of the Gargantuas"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

kenji_sahara = by_name.("Kenji", "Sahara")
kumi_mizuno = by_name.("Kumi", "Mizuno")
russ_tamblyn = by_name.("Russ", "Tamblyn")
jun_tazaki = by_name.("Jun", "Tazaki")
kipp_hamilton = by_name.("Kipp", "Hamilton")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
nobuo_nakamura = by_name.("Nobuo", "Nakamura")
hisaya_ito = by_name.("Hisaya", "Ito")
nadao_kirino = by_name.("Nadao", "Kirino")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
heihachiro_okawa = by_name.("Heihachiro", "Okawa")
shoichi_hirose = by_name.("Shoichi", "Hirose")
kozo_nomura = by_name.("Kozo", "Nomura")
ikio_sawamura = by_name.("Ikio", "Sawamura")
ren_yamamoto = by_name.("Ren", "Yamamoto")
yasuhiko_saijo = by_name.("Yasuhiko", "Saijo")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
wataru_omae = by_name.("Wataru", "Omae")
tadashi_okabe = by_name.("Tadashi", "Okabe")
yoshio_katsube = by_name.("Yoshio", "Katsube")
minoru_ito = by_name.("Minoru", "Ito")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
hideo_shibuya = by_name.("Hideo", "Shibuya")
yutaka_oka = by_name.("Yutaka", "Oka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
hiroshi_sekida = by_name.("Hiroshi", "Sekida")
goro_mutsumi = by_name.("Goro", "Mutsumi")
akio_kusama = by_name.("Akio", "Kusama")
junpei_natsuki = by_name.("Junpei", "Natsuki")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
keisuke_yamada = by_name.("Keisuke", "Yamada")
seishiro_kuno = by_name.("Seishiro", "Kuno")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
soji_ubukata = by_name.("Soji", "Ubukata")

roles = [
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: kenji_sahara.id,
    roles: ["Dr. Yuzo Majida"],
    order: 1
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: kumi_mizuno.id,
    roles: ["Akemi"],
    order: 2
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: russ_tamblyn.id,
    roles: ["Dr. Paul Stewart"],
    order: 3
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: jun_tazaki.id,
    roles: ["General Hashimoto"],
    order: 4
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: kipp_hamilton.id,
    roles: ["Nightclub Singer"],
    order: 5
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Coast Guard"],
    order: 6
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: nobuo_nakamura.id,
    roles: ["Dr. Kida"],
    order: 7
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: hisaya_ito.id,
    roles: ["Coast Guard"],
    order: 8
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: nadao_kirino.id,
    roles: ["Soldier"],
    order: 9
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Soldier"],
    order: 10
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: heihachiro_okawa.id,
    roles: ["Doctor"],
    order: 11
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: shoichi_hirose.id,
    roles: ["Guide"],
    order: 12
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: kozo_nomura.id,
    roles: ["Soldier"],
    order: 13
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: ikio_sawamura.id,
    roles: ["Fisherman"],
    order: 14
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: ren_yamamoto.id,
    roles: ["Sailor"],
    order: 15
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: yasuhiko_saijo.id,
    roles: ["Bystander"],
    order: 17
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: haruya_sakamoto.id,
    roles: ["Soldier"],
    order: 19
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Soldier"],
    order: 20
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: wataru_omae.id,
    roles: ["Air Traffic Controller"],
    order: 21
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: tadashi_okabe.id,
    roles: ["Reporter"],
    order: 24
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter"],
    order: 25
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: minoru_ito.id,
    roles: ["Reporter"],
    order: 26
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Military Advisor"],
    order: 27
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: takuzo_kumagai.id,
    roles: ["Military Advisor"],
    order: 28
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: masaaki_tachibana.id,
    roles: ["Reporter"],
    order: 31
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 32
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: yutaka_oka.id,
    roles: ["Reporter"],
    order: 33
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: haruo_nakajima.id,
    roles: ["Gaira"],
    order: 34
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: hiroshi_sekida.id,
    roles: ["Sanda"],
    order: 35
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: goro_mutsumi.id,
    roles: ["Dr. Paul Stewart (Voice)"],
    order: 36
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: akio_kusama.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: junpei_natsuki.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: keisuke_yamada.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: seishiro_kuno.id,
    roles: ["Fisherman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: gargantuas.id,
    person_id: rinsaku_ogata.id,
    roles: ["Soldier"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^gargantuas.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
