alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

human_vapor = Repo.one from f in Film, where: f.title == "The Human Vapor"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

tatsuya_mihashi = by_name.("Tatsuya", "Mihashi")
kaoru_yachigusa = by_name.("Kaoru", "Yachigusa")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
keiko_sata = by_name.("Keiko", "Sata")
hisaya_ito = by_name.("Hisaya", "Ito")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
bokuzen_hidari = by_name.("Bokuzen", "Hidari")
takamaru_sasaki = by_name.("Takamaru", "Sasaki")
minosuke_yamada = by_name.("Minosuke", "Yamada")
tatsuo_matsumura = by_name.("Tatsuo", "Matsumura")
yoyo_miyata = by_name.("Yoyo", "Miyata")
ko_mishima = by_name.("Ko", "Mishima")
kozo_nomura = by_name.("Kozo", "Nomura")
ren_yamamoto = by_name.("Ren", "Yamamoto")
somesho_matsumoto = by_name.("Somesho", "Matsumoto")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
shoichi_hirose = by_name.("Shoichi", "Hirose")
tetsu_nakamura = by_name.("Tetsu", "Nakamura")
toki_shiozawa = by_name.("Toki", "Shiozawa")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
keiji_sakakida = by_name.("Keiji", "Sakakida")
yutaka_oka = by_name.("Yutaka", "Oka")
keisuke_yamada = by_name.("Keisuke", "Yamada")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
akio_kusama = by_name.("Akio", "Kusama")
hideo_shibuya = by_name.("Hideo", "Shibuya")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
minoru_ito = by_name.("Minoru", "Ito")
wataru_omae = by_name.("Wataru", "Omae")
yoshio_katsube = by_name.("Yoshio", "Katsube")
ken_echigo = by_name.("Ken", "Echigo")
kazuo_hinata = by_name.("Kazuo", "Hinata")
junpei_natsuki = by_name.("Junpei", "Natsuki")
haruo_suzuki = by_name.("Haruo", "Suzuki")

roles = [
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: tatsuya_mihashi.id,
    roles: ["Detective Okamoto"],
    order: 1
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: kaoru_yachigusa.id,
    roles: ["Fujichiyo Kasuga"],
    order: 2
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Mizuno"],
    order: 3
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: keiko_sata.id,
    roles: ["Kyoko Kono"],
    order: 4
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: hisaya_ito.id,
    roles: ["Dr. Tamiya"],
    order: 5
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Detective Tabata"],
    order: 6
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yoshio_kosugi.id,
    roles: ["Detective Inao"],
    order: 7
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: fuyuki_murakami.id,
    roles: ["Dr. Sano"],
    order: 8
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: bokuzen_hidari.id,
    roles: ["Jiya (Kasuga's Manservant)"],
    order: 9
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: takamaru_sasaki.id,
    roles: ["Police Executive"],
    order: 10
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: minosuke_yamada.id,
    roles: ["Newspaper Executive"],
    order: 11
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: tatsuo_matsumura.id,
    roles: ["Newspaper Editor"],
    order: 12
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yoyo_miyata.id,
    roles: ["Bank Official"],
    order: 13
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: ko_mishima.id,
    roles: ["Detective Fujita"],
    order: 14
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: kozo_nomura.id,
    roles: ["Reporter Kawasaki"],
    order: 15
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: ren_yamamoto.id,
    roles: ["Nishiyama"],
    order: 16
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: somesho_matsumoto.id,
    roles: ["Kasuga's Instructor"],
    order: 17
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Policeman"],
    order: 18
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: shoichi_hirose.id,
    roles: ["Jail Officer"],
    order: 20
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: tetsu_nakamura.id,
    roles: ["Newspaper Executive"],
    order: 21
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: toki_shiozawa.id,
    roles: ["Instructor's Wife"],
    order: 22
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: takuzo_kumagai.id,
    roles: ["Newspaper Executive"],
    order: 23
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Detective Osaki"],
    order: 24
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: rinsaku_ogata.id,
    roles: ["Policeman"],
    order: 25
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: keiji_sakakida.id,
    roles: ["Jail Officer"],
    order: 26
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yutaka_oka.id,
    roles: ["Man in Audience"],
    order: 27
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: keisuke_yamada.id,
    roles: ["Police Executive"],
    order: 28
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yukihiko_gondo.id,
    roles: ["Detective Hotta"],
    order: 29
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: akio_kusama.id,
    roles: ["Police Executive"],
    order: 30
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: hideo_shibuya.id,
    roles: ["Banker"],
    order: 34
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: masaaki_tachibana.id,
    roles: ["Reporter"],
    order: 35
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: minoru_ito.id,
    roles: ["Reporter"],
    order: 38
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: wataru_omae.id,
    roles: ["Reporter"],
    order: 39
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: ken_echigo.id,
    roles: ["Scientist"],
    order: 99
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: kazuo_hinata.id,
    roles: ["Bank Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: junpei_natsuki.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: human_vapor.id,
    person_id: haruo_suzuki.id,
    roles: ["Policeman"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^human_vapor.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
