alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

frankenstein = Repo.one from f in Film, where: f.title == "Frankenstein Conquers the World"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

tadao_takashima = by_name.("Tadao", "Takashima")
nick_adams = by_name.("Nick", "Adams")
kumi_mizuno = by_name.("Kumi", "Mizuno")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
koji_furuhata = by_name.("Koji", "Furuhata")
jun_tazaki = by_name.("Jun", "Tazaki")
susumu_fujita = by_name.("Susumu", "Fujita")
takashi_shimura = by_name.("Takashi", "Shimura")
nobuo_nakamura = by_name.("Nobuo", "Nakamura")
kenji_sahara = by_name.("Kenji", "Sahara")
hisaya_ito = by_name.("Hisaya", "Ito")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
kozo_nomura = by_name.("Kozo", "Nomura")
haruya_kato = by_name.("Haruya", "Kato")
ikio_sawamura = by_name.("Ikio", "Sawamura")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
keiko_sawai = by_name.("Keiko", "Sawai")
peter_mann = by_name.("Peter", "Mann")
ren_yamamoto = by_name.("Ren", "Yamamoto")
yutaka_sada = by_name.("Yutaka", "Sada")
kenzo_tabu = by_name.("Kenzo", "Tabu")
shigeki_ishida = by_name.("Shigeki", "Ishida")
haruo_nakajima = by_name.("Haruo", "Nakajima")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
senkichi_omura = by_name.("Senkichi", "Omura")
nadao_kirino = by_name.("Nadao", "Kirino")
yasuhiko_saijo = by_name.("Yasuhiko", "Saijo")
shin_otomo = by_name.("Shin", "Otomo")
shoichi_hirose = by_name.("Shoichi", "Hirose")
junichiro_mukai = by_name.("Junichiro", "Mukai")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
hideo_shibuya = by_name.("Hideo", "Shibuya")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
tadashi_okabe = by_name.("Tadashi", "Okabe")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
yoshio_katsube = by_name.("Yoshio", "Katsube")
minoru_ito = by_name.("Minoru", "Ito")
keiji_sakakida = by_name.("Keiji", "Sakakida")
kazuo_hinata = by_name.("Kazuo", "Hinata")
akio_kusama = by_name.("Akio", "Kusama")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
junpei_natsuki = by_name.("Junpei", "Natsuki")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
haruo_suzuki = by_name.("Haruo", "Suzuki")

roles = [
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: tadao_takashima.id,
    roles: ["Dr. Yuzo Kawaji"],
    order: 1
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: nick_adams.id,
    roles: ["Dr. James Bowen"],
    order: 2
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: kumi_mizuno.id,
    roles: ["Dr. Sueko Togami"],
    order: 3
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Kawai"],
    order: 4
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: koji_furuhata.id,
    roles: ["Frankenstein"],
    order: 5
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: jun_tazaki.id,
    roles: ["Officer Nishi"],
    order: 6
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: susumu_fujita.id,
    roles: ["Osaka Police Chief"],
    order: 7
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: takashi_shimura.id,
    roles: ["Axis Scientist"],
    order: 8
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: nobuo_nakamura.id,
    roles: ["Skeptical Museum Curator"],
    order: 9
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: kenji_sahara.id,
    roles: ["Policeman"],
    order: 10
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: hisaya_ito.id,
    roles: ["Policeman"],
    order: 11
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Axis Submarine Captain"],
    order: 12
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: kozo_nomura.id,
    roles: ["Reporter"],
    order: 13
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: haruya_kato.id,
    roles: ["TV Reporter"],
    order: 14
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: ikio_sawamura.id,
    roles: ["Man Walking Dog"],
    order: 15
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: yoshio_kosugi.id,
    roles: ["Soldier"],
    order: 16
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: keiko_sawai.id,
    roles: ["Kazuko"],
    order: 18
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: peter_mann.id,
    roles: ["Dr. Liesendorf"],
    order: 20
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: ren_yamamoto.id,
    roles: ["Kawai's Assistant"],
    order: 21
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: yutaka_sada.id,
    roles: ["Laboratory Administrator"],
    order: 22
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: kenzo_tabu.id,
    roles: ["Skeptical Reporter"],
    order: 23
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: shigeki_ishida.id,
    roles: ["Skeptical Scientist"],
    order: 24
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: haruo_nakajima.id,
    roles: ["Baragon"],
    order: 25
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: yutaka_nakayama.id,
    roles: ["TV Reporter"],
    order: 26
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: senkichi_omura.id,
    roles: ["TV Cameraman"],
    order: 27
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: nadao_kirino.id,
    roles: ["Policeman"],
    order: 28
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: yasuhiko_saijo.id,
    roles: ["Reporter"],
    order: 29
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: shin_otomo.id,
    roles: ["Policeman"],
    order: 30
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: shoichi_hirose.id,
    roles: ["Miner"],
    order: 31
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: junichiro_mukai.id,
    roles: ["Village Policeman"],
    order: 32
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Miner"],
    order: 34
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 36
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: masaaki_tachibana.id,
    roles: ["Reporter"],
    order: 38
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: tadashi_okabe.id,
    roles: ["Reporter"],
    order: 39
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: rinsaku_ogata.id,
    roles: ["Soldier"],
    order: 40
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: yoshio_katsube.id,
    roles: ["Bystander"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: minoru_ito.id,
    roles: ["Scientist"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: keiji_sakakida.id,
    roles: ["Scientist"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: kazuo_hinata.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: akio_kusama.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: junpei_natsuki.id,
    roles: ["Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: haruya_sakamoto.id,
    roles: ["Axis Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: frankenstein.id,
    person_id: haruo_suzuki.id,
    roles: ["Reporter"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^frankenstein.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
