alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

telegian = Repo.one from f in Film, where: f.title == "The Secret of the Telegian"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

koji_tsuruta = by_name.("Koji", "Tsuruta")
yumi_shirakawa = by_name.("Yumi", "Shirakawa")
seizaburo_kawazu = by_name.("Seizaburo", "Kawazu")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
tadao_nakamaru = by_name.("Tadao", "Nakamaru")
akihiko_hirata = by_name.("Akihiko", "Hirata")
takamaru_sasaki = by_name.("Takamaru", "Sasaki")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
ikio_sawamura = by_name.("Ikio", "Sawamura")
sachio_sakai = by_name.("Sachio", "Sakai")
shin_otomo = by_name.("Shin", "Otomo")
ren_yamamoto = by_name.("Ren", "Yamamoto")
fuminto_matsuo = by_name.("Fuminto", "Matsuo")
senkichi_omura = by_name.("Senkichi", "Omura")
yutaka_sada = by_name.("Yutaka", "Sada")
akira_sera = by_name.("Akira", "Sera")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
shoichi_hirose = by_name.("Shoichi", "Hirose")
nadao_kirino = by_name.("Nadao", "Kirino")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
tadashi_okabe = by_name.("Tadashi", "Okabe")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
koji_uno = by_name.("Koji", "Uno")
tatsuo_matsumura = by_name.("Tatsuo", "Matsumura")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
yasuhiko_saijo = by_name.("Yasuhiko", "Saijo")
junichiro_mukai = by_name.("Junichiro", "Mukai")
hideo_shibuya = by_name.("Hideo", "Shibuya")
yoshio_katsube = by_name.("Yoshio", "Katsube")
minoru_ito = by_name.("Minoru", "Ito")
yutaka_oka = by_name.("Yutaka", "Oka")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
kazuo_hinata = by_name.("Kazuo", "Hinata")
akio_kusama = by_name.("Akio", "Kusama")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
ken_echigo = by_name.("Ken", "Echigo")

roles = [
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: koji_tsuruta.id,
    roles: ["Kirioka"],
    order: 1
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yumi_shirakawa.id,
    roles: ["Akiko Chujo"],
    order: 2
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: seizaburo_kawazu.id,
    roles: ["Onishi"],
    order: 3
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Detective Ozaki"],
    order: 4
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: tadao_nakamaru.id,
    roles: ["Tsudo"],
    order: 5
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: akihiko_hirata.id,
    roles: ["Detective Kobayashi"],
    order: 6
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: takamaru_sasaki.id,
    roles: ["Dr. Nikki"],
    order: 7
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Takamasa"],
    order: 8
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: fuyuki_murakami.id,
    roles: ["Dr. Miura"],
    order: 9
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: ikio_sawamura.id,
    roles: ["Thriller Show Announcer"],
    order: 10
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: sachio_sakai.id,
    roles: ["Taki"],
    order: 11
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: shin_otomo.id,
    roles: ["Tsukamoto"],
    order: 12
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: ren_yamamoto.id,
    roles: ["Detective Marune"],
    order: 13
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: fuminto_matsuo.id,
    roles: ["Reporter"],
    order: 14
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: senkichi_omura.id,
    roles: ["Islander"],
    order: 17
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yutaka_sada.id,
    roles: ["Policeman"],
    order: 18
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: akira_sera.id,
    roles: ["Caretaker"],
    order: 19
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: hideyo_amamoto.id,
    roles: ["Bodyguard"],
    order: 20
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: shoichi_hirose.id,
    roles: ["Bodyguard"],
    order: 21
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: nadao_kirino.id,
    roles: ["Bodyguard"],
    order: 22
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Police Executive"],
    order: 23
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: takuzo_kumagai.id,
    roles: ["Tourist"],
    order: 24
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: tadashi_okabe.id,
    roles: ["Policeman"],
    order: 26
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yutaka_nakayama.id,
    roles: ["Waiter"],
    order: 27
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: koji_uno.id,
    roles: ["Delivery Truck Driver"],
    order: 28
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: tatsuo_matsumura.id,
    roles: ["Newspaper Editor"],
    order: 29
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Reporter"],
    order: 30
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yasuhiko_saijo.id,
    roles: ["Reporter"],
    order: 35
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: junichiro_mukai.id,
    roles: ["Police Executive"],
    order: 40
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: hideo_shibuya.id,
    roles: ["Policeman"],
    order: 42
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yoshio_katsube.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: minoru_ito.id,
    roles: ["Thriller Show Employee"],
    order: 99
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yutaka_oka.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: yukihiko_gondo.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: kazuo_hinata.id,
    roles: ["Waiter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: akio_kusama.id,
    roles: ["Police Executive"],
    order: 99
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: masaaki_tachibana.id,
    roles: ["Crime Scene Investigator"],
    order: 99
  },
  %ActorPersonRole{
    film_id: telegian.id,
    person_id: ken_echigo.id,
    roles: ["Policeman"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^telegian.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
