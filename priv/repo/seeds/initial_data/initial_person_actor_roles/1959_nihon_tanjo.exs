alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

birth_of_japan = Repo.one from f in Film, where: f.title == "The Birth of Japan"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

toshiro_mifune = by_name.("Toshiro", "Mifune")
yoko_tsukasa = by_name.("Yoko", "Tsukasa")
kumi_mizuno = by_name.("Kumi", "Mizuno")
misa_uehara = by_name.("Misa", "Uehara")
kyoko_kagawa = by_name.("Kyoko", "Kagawa")
kinuyo_tanaka = by_name.("Kinuyo", "Tanaka")
nobuko_otowa = by_name.("Nobuko", "Otowa")
haruko_sugimura = by_name.("Haruko", "Sugimura")
akira_kubo = by_name.("Akira", "Kubo")
akira_takarada = by_name.("Akira", "Takarada")
ganjiro_nakamura = by_name.("Ganjiro", "Nakamura")
eijiro_tono = by_name.("Eijiro", "Tono")
akihiko_hirata = by_name.("Akihiko", "Hirata")
ko_mishima = by_name.("Ko", "Mishima")
hisaya_ito = by_name.("Hisaya", "Ito")
jun_tazaki = by_name.("Jun", "Tazaki")
takashi_shimura = by_name.("Takashi", "Shimura")
kichijiro_ueda = by_name.("Kichijiro", "Ueda")
yoshio_kosugi = by_name.("Yoshio", "Kosugi")
kozo_nomura = by_name.("Kozo", "Nomura")
yu_fujiki = by_name.("Yu", "Fujiki")
keiko_muramatsu = by_name.("Keiko", "Muramatsu")
chieko_nakakita = by_name.("Chieko", "Nakakita")
bokuzen_hidari = by_name.("Bokuzen", "Hidari")
minosuke_yamada = by_name.("Minosuke", "Yamada")
akira_sera = by_name.("Akira", "Sera")
hajime_izu = by_name.("Hajime", "Izu")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
fuyuki_murakami = by_name.("Fuyuki", "Murakami")
akira_tani = by_name.("Akira", "Tani")
junichiro_mukai = by_name.("Junichiro", "Mukai")
ikio_sawamura = by_name.("Ikio", "Sawamura")
senkichi_omura = by_name.("Senkichi", "Omura")
yutaka_sada = by_name.("Yutaka", "Sada")
mitsuo_tsuda = by_name.("Mitsuo", "Tsuda")
nadao_kirino = by_name.("Nadao", "Kirino")
shin_otomo = by_name.("Shin", "Otomo")
shoichi_hirose = by_name.("Shoichi", "Hirose")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
fuminto_matsuo = by_name.("Fuminto", "Matsuo")
yasuhisa_tsutsumi = by_name.("Yasuhisa", "Tsutsumi")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
hiroyuki_wakita = by_name.("Hiroyuki", "Wakita")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
keiju_kobayashi = by_name.("Keiju", "Kobayashi")
daisuke_kato = by_name.("Daisuke", "Kato")
norihei_miki = by_name.("Norihei", "Miki")
ichiro_arishima = by_name.("Ichiro", "Arishima")
kingoro_yanagiya = by_name.("Kingoro", "Yanagiya")
kenichi_enomoto = by_name.("Kenichi", "Enomoto")
taro_asahiyo = by_name.("Taro", "Asahiyo")
koji_tsuruta = by_name.("Koji", "Tsuruta")
setsuko_hara = by_name.("Setsuko", "Hara")
akio_kusama = by_name.("Akio", "Kusama")
ren_yamamoto = by_name.("Ren", "Yamamoto")
naoya_kusakawa = by_name.("Naoya", "Kusakawa")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
ken_echigo = by_name.("Ken", "Echigo")
keiji_sakakida = by_name.("Keiji", "Sakakida")
kazuo_hinata = by_name.("Kazuo", "Hinata")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
junpei_natsuki = by_name.("Junpei", "Natsuki")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
yutaka_oka = by_name.("Yutaka", "Oka")

roles = [
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: toshiro_mifune.id,
    roles: ["Prince Ousu", "Susano-o"],
    order: 1
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yoko_tsukasa.id,
    roles: ["Oto Tachibana"],
    order: 2
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kumi_mizuno.id,
    roles: ["Azami"],
    order: 3
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: misa_uehara.id,
    roles: ["Kushinada"],
    order: 4
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kyoko_kagawa.id,
    roles: ["Princess Miyazu"],
    order: 5
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kinuyo_tanaka.id,
    roles: ["Princess Yamato"],
    order: 6
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: nobuko_otowa.id,
    roles: ["Dancing Goddess"],
    order: 7
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: haruko_sugimura.id,
    roles: ["Storyteller"],
    order: 8
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: akira_kubo.id,
    roles: ["Prince Ioki"],
    order: 9
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: akira_takarada.id,
    roles: ["Prince Wakatarashi"],
    order: 10
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: ganjiro_nakamura.id,
    roles: ["Emperor Keiko"],
    order: 11
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: eijiro_tono.id,
    roles: ["Otomo"],
    order: 12
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: akihiko_hirata.id,
    roles: ["Takehiko"],
    order: 13
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: ko_mishima.id,
    roles: ["Yakumo"],
    order: 14
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: hisaya_ito.id,
    roles: ["Kodate Otomo"],
    order: 15
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: jun_tazaki.id,
    roles: ["Kurohiko"],
    order: 16
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: takashi_shimura.id,
    roles: ["Elder Kumaso"],
    order: 17
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kichijiro_ueda.id,
    roles: ["Hachihara"],
    order: 18
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yoshio_kosugi.id,
    roles: ["Inaba"],
    order: 19
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kozo_nomura.id,
    roles: ["Makeri Otomo"],
    order: 20
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yu_fujiki.id,
    roles: ["Kojikahi"],
    order: 21
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: keiko_muramatsu.id,
    roles: ["Izanami"],
    order: 23
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: chieko_nakakita.id,
    roles: ["Tenazuchi"],
    order: 25
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: bokuzen_hidari.id,
    roles: ["Deity"],
    order: 26
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: minosuke_yamada.id,
    roles: ["Okuri"],
    order: 27
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: akira_sera.id,
    roles: ["Anazuchi"],
    order: 28
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: hajime_izu.id,
    roles: ["Prince Oji"],
    order: 29
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Deity"],
    order: 30
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: fuyuki_murakami.id,
    roles: ["Deity"],
    order: 31
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: akira_tani.id,
    roles: ["Deity"],
    order: 32
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: junichiro_mukai.id,
    roles: ["Moroto"],
    order: 33
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: ikio_sawamura.id,
    roles: ["Deity"],
    order: 34
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: senkichi_omura.id,
    roles: ["Yamato Villager"],
    order: 35
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yutaka_sada.id,
    roles: ["Yamato Villager"],
    order: 36
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Yamato Soldier"],
    order: 39
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: nadao_kirino.id,
    roles: ["Yamato Soldier"],
    order: 40
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: shin_otomo.id,
    roles: ["Kumaso Soldier"],
    order: 41
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: shoichi_hirose.id,
    roles: ["Kumaso Soldier"],
    order: 44
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Yamato Soldier"],
    order: 45
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: fuminto_matsuo.id,
    roles: ["Yamato Villager"],
    order: 46
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Yamato Soldier"],
    order: 47
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: takuzo_kumagai.id,
    roles: ["Yamato Villager"],
    order: 49
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: haruya_sakamoto.id,
    roles: ["Yamato Soldier"],
    order: 53
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: rinsaku_ogata.id,
    roles: ["Yamato Soldier"],
    order: 54
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: hiroyuki_wakita.id,
    roles: ["Izanagi"],
    order: 59
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: hideyo_amamoto.id,
    roles: ["Deity"],
    order: 60
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: keiju_kobayashi.id,
    roles: ["Amatsumara"],
    order: 70
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: daisuke_kato.id,
    roles: ["Futodama"],
    order: 71
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: norihei_miki.id,
    roles: ["Koyane"],
    order: 72
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: ichiro_arishima.id,
    roles: ["Ridouri"],
    order: 73
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kingoro_yanagiya.id,
    roles: ["Omoikane"],
    order: 74
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kenichi_enomoto.id,
    roles: ["Tamaso"],
    order: 75
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: taro_asahiyo.id,
    roles: ["Tajikarao"],
    order: 76
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: koji_tsuruta.id,
    roles: ["Younger Kumaso"],
    order: 77
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: setsuko_hara.id,
    roles: ["Amaterasu"],
    order: 78
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: akio_kusama.id,
    roles: ["Deity", "Yamato Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: ren_yamamoto.id,
    roles: ["Yamato Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: naoya_kusakawa.id,
    roles: ["Utte Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: masaaki_tachibana.id,
    roles: ["Yamato Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: ken_echigo.id,
    roles: ["Yamato Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: keiji_sakakida.id,
    roles: ["Yamato Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kazuo_hinata.id,
    roles: ["Utte Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Otomo Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: junpei_natsuki.id,
    roles: ["Owari Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yukihiko_gondo.id,
    roles: ["Yamato Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: birth_of_japan.id,
    person_id: yutaka_oka.id,
    roles: ["Deity"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^birth_of_japan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
