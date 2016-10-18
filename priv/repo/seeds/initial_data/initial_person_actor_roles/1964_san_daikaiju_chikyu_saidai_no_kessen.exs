alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

ghidorah = Repo.one from f in Film, where: f.title == "Ghidorah, the Three-Headed Monster"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

yosuke_natsuki = by_name.("Yosuke", "Natsuki")
yuriko_hoshi = by_name.("Yuriko", "Hoshi")
hiroshi_koizumi = by_name.("Hiroshi", "Koizumi")
takashi_shimura = by_name.("Takashi", "Shimura")
akiko_wakabayashi = by_name.("Akiko", "Wakabayashi")
hisaya_ito = by_name.("Hisaya", "Ito")
susumu_kurobe = by_name.("Susumu", "Kurobe")
akihiko_hirata = by_name.("Akihiko", "Hirata")
kenji_sahara = by_name.("Kenji", "Sahara")
toru_ibuki = by_name.("Toru", "Ibuki")
kozo_nomura = by_name.("Kozo", "Nomura")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
minoru_takada = by_name.("Minoru", "Takada")
yuriko_hanabusa = by_name.("Yuriko", "Hanabusa")
haruya_kato = by_name.("Haruya", "Kato")
ikio_sawamura = by_name.("Ikio", "Sawamura")
nakajiro_tomita = by_name.("Nakajiro", "Tomita")
shigeki_ishida = by_name.("Shigeki", "Ishida")
shin_otomo = by_name.("Shin", "Otomo")
yutaka_nakayama = by_name.("Yutaka", "Nakayama")
senkichi_omura = by_name.("Senkichi", "Omura")
somesho_matsumoto = by_name.("Somesho", "Matsumoto")
kazuo_suzuki = by_name.("Kazuo", "Suzuki")
senya_aozora = by_name.("Senya", "Aozora")
ichiya_aozora = by_name.("Ichiya", "Aozora")
shoichi_hirose = by_name.("Shoichi", "Hirose")
heihachiro_okawa = by_name.("Heihachiro", "Okawa")
junichiro_mukai = by_name.("Junichiro", "Mukai")
hideo_shibuya = by_name.("Hideo", "Shibuya")
katsumi_tezuka = by_name.("Katsumi", "Tezuka")
koji_uno = by_name.("Koji", "Uno")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
yoshio_katsube = by_name.("Yoshio", "Katsube")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
ken_echigo = by_name.("Ken", "Echigo")
yutaka_oka = by_name.("Yutaka", "Oka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
seishiro_kuno = by_name.("Seishiro", "Kuno")
minoru_ito = by_name.("Minoru", "Ito")
masaki_shinohara = by_name.("Masaki", "Shinohara")
tadashi_okabe = by_name.("Tadashi", "Okabe")
kazuo_hinata = by_name.("Kazuo", "Hinata")
keisuke_yamada = by_name.("Keisuke", "Yamada")
keiji_sakakida = by_name.("Keiji", "Sakakida")
junpei_natsuki = by_name.("Junpei", "Natsuki")
akio_kusama = by_name.("Akio", "Kusama")

roles = [
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yosuke_natsuki.id,
    roles: ["Detective Shindo"],
    order: 1
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yuriko_hoshi.id,
    roles: ["Naoko Shindo"],
    order: 2
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: hiroshi_koizumi.id,
    roles: ["Dr. Murai"],
    order: 3
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: takashi_shimura.id,
    roles: ["Dr. Tsukamoto"],
    order: 4
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: akiko_wakabayashi.id,
    roles: ["Princess Salno"],
    order: 6
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: hisaya_ito.id,
    roles: ["Malmess"],
    order: 7
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: susumu_kurobe.id,
    roles: ["Assassin"],
    order: 8
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: akihiko_hirata.id,
    roles: ["Chief Okita"],
    order: 9
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: kenji_sahara.id,
    roles: ["Newspaper Editor"],
    order: 10
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: toru_ibuki.id,
    roles: ["Assassin"],
    order: 11
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: kozo_nomura.id,
    roles: ["Geologist"],
    order: 12
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Cruise Ship Captain"],
    order: 13
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: hideyo_amamoto.id,
    roles: ["Salno's Manservant"],
    order: 14
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yoshio_kosugi.id,
    roles: ["Infant Island Chief"],
    order: 15
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: minoru_takada.id,
    roles: ["Defense Minister"],
    order: 16
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yuriko_hanabusa.id,
    roles: ["Mrs. Shindo"],
    order: 17
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: haruya_kato.id,
    roles: ["Reporter"],
    order: 18
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: ikio_sawamura.id,
    roles: ["Fisherman"],
    order: 19
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: nakajiro_tomita.id,
    roles: ["General"],
    order: 20
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: shigeki_ishida.id,
    roles: ["Parliamentarian"],
    order: 21
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: shin_otomo.id,
    roles: ["Sergina Opposition Leader"],
    order: 22
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yutaka_nakayama.id,
    roles: ["Mt. Aso Tourist"],
    order: 23
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: senkichi_omura.id,
    roles: ["Mt. Aso Tourist"],
    order: 24
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: somesho_matsumoto.id,
    roles: ["UFO Club President"],
    order: 25
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: kazuo_suzuki.id,
    roles: ["Assassin"],
    order: 26
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: senya_aozora.id,
    roles: ["TV Presenter"],
    order: 27
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: ichiya_aozora.id,
    roles: ["TV Presenter"],
    order: 28
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: shoichi_hirose.id,
    roles: ["King Ghidorah", "Villager"],
    order: 29
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: heihachiro_okawa.id,
    roles: ["UFO Club Member"],
    order: 30
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: junichiro_mukai.id,
    roles: ["Parliamentarian"],
    order: 31
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: hideo_shibuya.id,
    roles: ["Volcanologist", "Villager"],
    order: 34
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: katsumi_tezuka.id,
    roles: ["Godzilla"],
    order: 36
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: koji_uno.id,
    roles: ["Hotel Clerk"],
    order: 37
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: takuzo_kumagai.id,
    roles: ["Parliamentarian"],
    order: 41
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Parliamentarian"],
    order: 42
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter"],
    order: 43
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Sailor"],
    order: 44
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: ken_echigo.id,
    roles: ["Bystander"],
    order: 47
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: yutaka_oka.id,
    roles: ["Dam Worker"],
    order: 51
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla"],
    order: 52
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: haruya_sakamoto.id,
    roles: ["Geologist"],
    order: 54
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: seishiro_kuno.id,
    roles: ["Waiter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: minoru_ito.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: masaki_shinohara.id,
    roles: ["Rodan"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: tadashi_okabe.id,
    roles: ["Tsukamoto's Assistant"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: kazuo_hinata.id,
    roles: ["Parliamentarian", "Serginan on Plane"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: keisuke_yamada.id,
    roles: ["Prime Minister"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: keiji_sakakida.id,
    roles: ["Serginan Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: junpei_natsuki.id,
    roles: ["UFO Club Member"],
    order: 99
  },
  %ActorPersonRole{
    film_id: ghidorah.id,
    person_id: akio_kusama.id,
    roles: ["Parliamentarian"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^ghidorah.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
