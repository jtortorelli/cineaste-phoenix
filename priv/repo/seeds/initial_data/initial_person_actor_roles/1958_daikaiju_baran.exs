alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

varan = Repo.one from f in Film, where: f.title == "Varan the Unbelievable"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

kozo_nomura = by_name.("Kozo", "Nomura")
ayumi_sonoda = by_name.("Ayumi", "Sonoda")
koreya_senda = by_name.("Koreya", "Senda")
akihiko_hirata = by_name.("Akihiko", "Hirata")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
minosuke_yamada = by_name.("Minosuke", "Yamada")
hisaya_ito = by_name.("Hisaya", "Ito")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
nadao_kirino = by_name.("Nadao", "Kirino")
akira_sera = by_name.("Akira", "Sera")
akio_kusama = by_name.("Akio", "Kusama")
fuminto_matsuo = by_name.("Fuminto", "Matsuo")
soji_ubukata = by_name.("Soji", "Ubukata")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
shoichi_hirose = by_name.("Shoichi", "Hirose")
keisuke_yamada = by_name.("Keisuke", "Yamada")
hideo_shibuya = by_name.("Hideo", "Shibuya")
masaki_shinohara = by_name.("Masaki", "Shinohara")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
junichiro_mukai = by_name.("Junichiro", "Mukai")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
yoshio_katsube = by_name.("Yoshio", "Katsube")
keiji_sakakida = by_name.("Keiji", "Sakakida")
yutaka_oka = by_name.("Yutaka", "Oka")

roles = [
  %ActorPersonRole{
    film_id: varan.id,
    person_id: kozo_nomura.id,
    roles: ["Kenji Uozaki"],
    order: 1
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: ayumi_sonoda.id,
    roles: ["Yuriko Shinjo"],
    order: 2
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: koreya_senda.id,
    roles: ["Dr. Sugimoto"],
    order: 3
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: akihiko_hirata.id,
    roles: ["Dr. Fujimora"],
    order: 4
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: fuyuki_murakami.id,
    roles: ["Dr. Majima"],
    order: 5
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Officer Katsumoto"],
    order: 6
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: minosuke_yamada.id,
    roles: ["Defense Secretary"],
    order: 7
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: hisaya_ito.id,
    roles: ["Ichiro Shinjo"],
    order: 8
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Naval Officer"],
    order: 9
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: nadao_kirino.id,
    roles: ["Yutaka Wada"],
    order: 10
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: akira_sera.id,
    roles: ["Village Priest"],
    order: 11
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: akio_kusama.id,
    roles: ["Soldier"],
    order: 12
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: fuminto_matsuo.id,
    roles: ["Horiguchi"],
    order: 15
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: soji_ubukata.id,
    roles: ["Policeman"],
    order: 16
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Soldier"],
    order: 21
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: takuzo_kumagai.id,
    roles: ["Soldier"],
    order: 22
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: shoichi_hirose.id,
    roles: ["Fisherman"],
    order: 23
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: keisuke_yamada.id,
    roles: ["Soldier"],
    order: 24
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 25
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: masaki_shinohara.id,
    roles: ["Fisherman"],
    order: 27
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: rinsaku_ogata.id,
    roles: ["Soldier"],
    order: 33
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: junichiro_mukai.id,
    roles: ["Soldier"],
    order: 34
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: haruya_sakamoto.id,
    roles: ["Soldier"],
    order: 40
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: katsumi_tezuka.id,
    roles: ["Varan"],
    order: 46
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: haruo_nakajima.id,
    roles: ["Varan"],
    order: 47
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: keiji_sakakida.id,
    roles: ["Truck Driver"],
    order: 99
  },
  %ActorPersonRole{
    film_id: varan.id,
    person_id: yutaka_oka.id,
    roles: ["Bomber Pilot"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^varan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
