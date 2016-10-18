alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

taklamakan = Repo.one from f in Film, where: f.title == "The Adventure of Taklamakan"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

toshiro_mifune = by_name.("Toshiro", "Mifune")
tatsuya_mihashi = by_name.("Tatsuya", "Mihashi")
tadao_nakamaru = by_name.("Tadao", "Nakamaru")
makoto_sato = by_name.("Makoto", "Sato")
mie_hama = by_name.("Mie", "Hama")
akiko_wakabayashi = by_name.("Akiko", "Wakabayashi")
yumi_shirakawa = by_name.("Yumi", "Shirakawa")
ichiro_arishima = by_name.("Ichiro", "Arishima")
jun_tazaki = by_name.("Jun", "Tazaki")
akihiko_hirata = by_name.("Akihiko", "Hirata")
susumu_kurobe = by_name.("Susumu", "Kurobe")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
toshio_kurosawa = by_name.("Toshio", "Kurosawa")
hiroko_sakurai = by_name.("Hiroko", "Sakurai")
shoji_oki = by_name.("Shoji", "Oki")
sachio_sakai = by_name.("Sachio", "Sakai")
shigeki_ishida = by_name.("Shigeki", "Ishida")
shunji_kasuga = by_name.("Shunji", "Kasuga")
naoya_kusakawa = by_name.("Naoya", "Kusakawa")
ren_yamamoto = by_name.("Ren", "Yamamoto")
ikio_sawamura = by_name.("Ikio", "Sawamura")
minoru_takada = by_name.("Minoru", "Takada")
hiroshi_hasegawa = by_name.("Hiroshi", "Hasegawa")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
minoru_ito = by_name.("Minoru", "Ito")
yoshio_katsube = by_name.("Yoshio", "Katsube")
yukihiko_gondo = by_name.("Yukihiko", "Gondo")
junpei_natsuki = by_name.("Junpei", "Natsuki")
keiji_sakakida = by_name.("Keiji", "Sakakida")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")

roles = [
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: toshiro_mifune.id,
    roles: ["Osami"],
    order: 1
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: tatsuya_mihashi.id,
    roles: ["The King"],
    order: 2
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: tadao_nakamaru.id,
    roles: ["Ensai"],
    order: 3
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: makoto_sato.id,
    roles: ["Gorjaka the Bandit"],
    order: 4
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: mie_hama.id,
    roles: ["The Innkeeper's Daughter"],
    order: 5
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: akiko_wakabayashi.id,
    roles: ["The Chamberlain's Daughter"],
    order: 6
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: yumi_shirakawa.id,
    roles: ["The Queen"],
    order: 7
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: ichiro_arishima.id,
    roles: ["The Wizard Hermit"],
    order: 8
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: jun_tazaki.id,
    roles: ["The Innkeeper"],
    order: 9
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: akihiko_hirata.id,
    roles: ["The Chamberlain"],
    order: 10
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: susumu_kurobe.id,
    roles: ["Palace Guard"],
    order: 11
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: hideyo_amamoto.id,
    roles: ["Granny the Witch"],
    order: 12
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: toshio_kurosawa.id,
    roles: ["Osami's Brother"],
    order: 13
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: hiroko_sakurai.id,
    roles: ["The Queen's Handmaiden"],
    order: 14
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: shoji_oki.id,
    roles: ["Sundara"],
    order: 15
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: sachio_sakai.id,
    roles: ["Caravan Leader"],
    order: 16
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: shigeki_ishida.id,
    roles: ["Royal Advisor"],
    order: 17
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: shunji_kasuga.id,
    roles: ["Royal Advisor"],
    order: 18
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: naoya_kusakawa.id,
    roles: ["Palace Guard"],
    order: 19
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: ren_yamamoto.id,
    roles: ["Jailkeeper"],
    order: 20
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: ikio_sawamura.id,
    roles: ["Slave Auctioneer"],
    order: 21
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: minoru_ito.id,
    roles: ["Buddhist Priest"],
    order: 22
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: hiroshi_hasegawa.id,
    roles: ["Palace Guard"],
    order: 25
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Merchant"],
    order: 27
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: minoru_ito.id,
    roles: ["Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: yoshio_katsube.id,
    roles: ["Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: yukihiko_gondo.id,
    roles: ["Palace Guard"],
    order: 99
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: junpei_natsuki.id,
    roles: ["Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: keiji_sakakida.id,
    roles: ["Villager"],
    order: 99
  },
  %ActorPersonRole{
    film_id: taklamakan.id,
    person_id: masaaki_tachibana.id,
    roles: ["Villager"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^taklamakan.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
