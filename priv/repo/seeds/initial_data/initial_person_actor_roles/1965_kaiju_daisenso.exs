alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

monster_zero = Repo.one from f in Film, where: f.title == "Monster Zero"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

akira_takarada = by_name.("Akira", "Takarada")
nick_adams = by_name.("Nick", "Adams")
kumi_mizuno = by_name.("Kumi", "Mizuno")
keiko_sawai = by_name.("Keiko", "Sawai")
jun_tazaki = by_name.("Jun", "Tazaki")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
akira_kubo = by_name.("Akira", "Kubo")
takamaru_sasaki = by_name.("Takamaru", "Sasaki")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
kenzo_tabu = by_name.("Kenzo", "Tabu")
noriko_sengoku = by_name.("Noriko", "Sengoku")
somesho_matsumoto = by_name.("Somesho", "Matsumoto")
gen_shimizu = by_name.("Gen", "Shimizu")
toru_ibuki = by_name.("Toru", "Ibuki")
kazuo_suzuki = by_name.("Kazuo", "Suzuki")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
nadao_kirino = by_name.("Nadao", "Kirino")
toki_shiozawa = by_name.("Toki", "Shiozawa")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
koji_uno = by_name.("Koji", "Uno")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
yutaka_oka = by_name.("Yutaka", "Oka")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
tadashi_okabe = by_name.("Tadashi", "Okabe")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
minoru_ito = by_name.("Minoru", "Ito")
haruo_nakajima = by_name.("Haruo", "Nakajima")
masaki_shinohara = by_name.("Masaki", "Shinohara")
shoichi_hirose = by_name.("Shoichi", "Hirose")
akio_kusama = by_name.("Akio", "Kusama")
haruo_suzuki = by_name.("Haruo", "Suzuki")
akira_wakamatsu = by_name.("Akira", "Wakamatsu")
junpei_natsuki = by_name.("Junpei", "Natsuki")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
keisuke_yamada = by_name.("Keisuke", "Yamada")
kazuo_hinata = by_name.("Kazuo", "Hinata")
yoshio_katsube = by_name.("Yoshio", "Katsube")
saburo_iketani = by_name.("Saburo", "Iketani")

roles = [
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: akira_takarada.id,
    roles: ["Astronaut Fuji"],
    order: 1
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: nick_adams.id,
    roles: ["Astronaut Glenn"],
    order: 2
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: kumi_mizuno.id,
    roles: ["Namikawa"],
    order: 3
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: keiko_sawai.id,
    roles: ["Haruno Fuji"],
    order: 4
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: jun_tazaki.id,
    roles: ["Dr. Sakurai"],
    order: 5
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["The Controller of Planet X"],
    order: 6
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: akira_kubo.id,
    roles: ["Tetsuo"],
    order: 7
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: takamaru_sasaki.id,
    roles: ["Prime Minister"],
    order: 8
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: fuyuki_murakami.id,
    roles: ["Minister"],
    order: 9
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Soldier"],
    order: 10
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: kenzo_tabu.id,
    roles: ["Xian Commander"],
    order: 11
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: noriko_sengoku.id,
    roles: ["Tetsuo's Landlady"],
    order: 12
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: somesho_matsumoto.id,
    roles: ["Priest"],
    order: 13
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: gen_shimizu.id,
    roles: ["General"],
    order: 14
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: toru_ibuki.id,
    roles: ["Xian"],
    order: 15
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: kazuo_suzuki.id,
    roles: ["Xian"],
    order: 16
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Soldier"],
    order: 17
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: nadao_kirino.id,
    roles: ["Soldier"],
    order: 18
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: toki_shiozawa.id,
    roles: ["Minister"],
    order: 19
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Soldier"],
    order: 20
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: takuzo_kumagai.id,
    roles: ["Soldier"],
    order: 21
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: koji_uno.id,
    roles: ["Xian"],
    order: 22
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: masaaki_tachibana.id,
    roles: ["Scientist"],
    order: 23
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: yutaka_oka.id,
    roles: ["Reporter"],
    order: 24
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: rinsaku_ogata.id,
    roles: ["Soldier"],
    order: 25
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: tadashi_okabe.id,
    roles: ["Reporter"],
    order: 26
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Reporter"],
    order: 29
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: minoru_ito.id,
    roles: ["Reporter"],
    order: 30
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla"],
    order: 31
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: masaki_shinohara.id,
    roles: ["Rodan"],
    order: 32
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: shoichi_hirose.id,
    roles: ["King Ghidorah"],
    order: 33
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: akio_kusama.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: haruo_suzuki.id,
    roles: ["Xian"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: akira_wakamatsu.id,
    roles: ["Xian"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: junpei_natsuki.id,
    roles: ["Scientist"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: haruya_sakamoto.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: keisuke_yamada.id,
    roles: ["Minister"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: kazuo_hinata.id,
    roles: ["Scientist"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: yoshio_katsube.id,
    roles: ["Xian"],
    order: 99
  },
  %ActorPersonRole{
    film_id: monster_zero.id,
    person_id: saburo_iketani.id,
    roles: ["Radio Announcer"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^monster_zero.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
