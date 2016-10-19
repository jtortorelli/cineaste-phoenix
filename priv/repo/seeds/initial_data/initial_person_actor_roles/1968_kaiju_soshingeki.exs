alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

destroy_all_monsters = Repo.one from f in Film, where: f.title == "Destroy All Monsters"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

akira_kubo = by_name.("Akira", "Kubo")
yukiko_kobayashi = by_name.("Yukiko", "Kobayashi")
kyoko_ai = by_name.("Kyoko", "Ai")
jun_tazaki = by_name.("Jun", "Tazaki")
yoshio_tsuchiya = by_name.("Yoshio", "Tsuchiya")
kenji_sahara = by_name.("Kenji", "Sahara")
susumu_kurobe = by_name.("Susumu", "Kurobe")
hisaya_ito = by_name.("Hisaya", "Ito")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
nadao_kirino = by_name.("Nadao", "Kirino")
naoya_kusakawa = by_name.("Naoya", "Kusakawa")
ikio_sawamura = by_name.("Ikio", "Sawamura")
wataru_omae = by_name.("Wataru", "Omae")
kazuo_suzuki = by_name.("Kazuo", "Suzuki")
yutaka_sada = by_name.("Yutaka", "Sada")
chotaro_togin = by_name.("Chotaro", "Togin")
yasuhiko_saijo = by_name.("Yasuhiko", "Saijo")
seishiro_kuno = by_name.("Seishiro", "Kuno")
kenichiro_maruyama = by_name.("Kenichiro", "Maruyama")
toru_ibuki = by_name.("Toru", "Ibuki")
ken_echigo = by_name.("Ken", "Echigo")
minoru_ito = by_name.("Minoru", "Ito")
hideo_shibuya = by_name.("Hideo", "Shibuya")
yoshio_katsube = by_name.("Yoshio", "Katsube")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
tadashi_okabe = by_name.("Tadashi", "Okabe")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
yutaka_oka = by_name.("Yutaka", "Oka")
haruo_nakajima = by_name.("Haruo", "Nakajima")
hiroshi_sekida = by_name.("Hiroshi", "Sekida")
teruo_aragaki = by_name.("Teruo", "Aragaki")
susumu_utsumi = by_name.("Susumu", "Utsumi")
masao_fukasawa = by_name.("Masao", "Fukasawa")
saburo_iketani = by_name.("Saburo", "Iketani")
heihachiro_okawa = by_name.("Heihachiro", "Okawa")
andrew_hughes = by_name.("Andrew", "Hughes")
junpei_natsuki = by_name.("Junpei", "Natsuki")
kazuo_hinata = by_name.("Kazuo", "Hinata")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
soji_ubukata = by_name.("Soji", "Ubukata")
akio_kusama = by_name.("Akio", "Kusama")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")

roles = [
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: akira_kubo.id,
    roles: ["Katsuo Yamabe"],
    order: 1
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yukiko_kobayashi.id,
    roles: ["Kyoko Manabe"],
    order: 2
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: kyoko_ai.id,
    roles: ["Kilaak Queen"],
    order: 3
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: jun_tazaki.id,
    roles: ["Dr, Yoshido"],
    order: 4
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Dr. Otani"],
    order: 5
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: kenji_sahara.id,
    roles: ["Moon Base Commander Nishikawa"],
    order: 6
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: susumu_kurobe.id,
    roles: ["Possessed Monster Island Tech"],
    order: 7
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: hisaya_ito.id,
    roles: ["Major Tada"],
    order: 8
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Defense Chief Sugiyama"],
    order: 9
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: nadao_kirino.id,
    roles: ["Special Police"],
    order: 10
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: naoya_kusakawa.id,
    roles: ["Special Police"],
    order: 11
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: ikio_sawamura.id,
    roles: ["Mountaineer"],
    order: 12
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: wataru_omae.id,
    roles: ["SY-3 Pilot"],
    order: 13
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: kazuo_suzuki.id,
    roles: ["Possessed Monster Island Tech"],
    order: 14
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yutaka_sada.id,
    roles: ["Village Policeman"],
    order: 15
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: chotaro_togin.id,
    roles: ["SY-3 Pilot Ogata"],
    order: 16
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yasuhiko_saijo.id,
    roles: ["SY-3 Pilot"],
    order: 17
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: seishiro_kuno.id,
    roles: ["SY-3 Pilot"],
    order: 18
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: kenichiro_maruyama.id,
    roles: ["Moon Base Tech"],
    order: 19
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: toru_ibuki.id,
    roles: ["Possessed Monster Island Tech"],
    order: 20
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: ken_echigo.id,
    roles: ["SY-3 Pilot"],
    order: 21
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: minoru_ito.id,
    roles: ["Possessed Monster Island Tech"],
    order: 22
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 23
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yoshio_katsube.id,
    roles: ["UNSC Tech"],
    order: 24
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Special Police"],
    order: 25
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: tadashi_okabe.id,
    roles: ["Mt. Fuji Reporter"],
    order: 26
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: haruya_sakamoto.id,
    roles: ["Military Advisor"],
    order: 27
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: rinsaku_ogata.id,
    roles: ["Military Advisor"],
    order: 28
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yukihiko_gondo.id,
    roles: ["Soldier"],
    order: 29
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: yutaka_oka.id,
    roles: ["Reporter"],
    order: 30
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla", "Military Advisor"],
    order: 36
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: hiroshi_sekida.id,
    roles: ["Anguirus", "Gorosaurus"],
    order: 37
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: teruo_aragaki.id,
    roles: ["Rodan"],
    order: 38
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: susumu_utsumi.id,
    roles: ["King Ghidorah"],
    order: 39
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: masao_fukasawa.id,
    roles: ["Minya"],
    order: 40
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: saburo_iketani.id,
    roles: ["Radio Announcer"],
    order: 41
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: heihachiro_okawa.id,
    roles: ["UNSC Scientist"],
    order: 42
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: andrew_hughes.id,
    roles: ["Dr. Stevenson"],
    order: 43
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: junpei_natsuki.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: kazuo_hinata.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: masaaki_tachibana.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: soji_ubukata.id,
    roles: ["Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: akio_kusama.id,
    roles: ["Monster Island Tech", "Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: destroy_all_monsters.id,
    person_id: takuzo_kumagai.id,
    roles: ["Reporter"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^destroy_all_monsters.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
