alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

godzilla_raids_again = Repo.one from f in Film, where: f.title == "Godzilla Raids Again"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

hiroshi_koizumi = Repo.one(by_name.("Hiroshi", "Koizumi"))
setsuko_wakayama = Repo.one(by_name.("Setsuko", "Wakayama"))
minoru_chiaki = Repo.one(by_name.("Minoru", "Chiaki"))
takashi_shimura = Repo.one(by_name.("Takashi", "Shimura"))
masao_shimizu = Repo.one(by_name.("Masao", "Shimizu"))
seijiro_onda = Repo.one(by_name.("Seijiro", "Onda"))
sonosuke_sawamura = Repo.one(by_name.("Sonosuke", "Sawamura"))
yoshio_tsuchiya = Repo.one(by_name.("Yoshio", "Tsuchiya"))
mayuri_mokusho = Repo.one(by_name.("Mayuri", "Mokusho"))
minosuke_yamada = Repo.one(by_name.("Minosuke", "Yamada"))
yukio_kasama = Repo.one(by_name.("Yukio", "Kasama"))
senkichi_omura = Repo.one(by_name.("Senkichi", "Omura"))
ren_yamamoto = Repo.one(by_name.("Ren", "Yamamoto"))
shin_otomo = Repo.one(by_name.("Shin", "Otomo"))
shiro_tsuchiya = Repo.one(by_name.("Shiro", "Tsuchiya"))
takeo_oikawa = Repo.one(by_name.("Takeo", "Oikawa"))
sokichi_maki = Repo.one(by_name.("Sokichi", "Maki"))
shoichi_hirose = Repo.one(by_name.("Shoichi", "Hirose"))
junpei_natsuki = Repo.one(by_name.("Junpei", "Natsuki"))
katsumi_tezuka = Repo.one(by_name.("Katsumi", "Tezuka"))
haruo_nakajima = Repo.one(by_name.("Haruo", "Nakajima"))
miyoko_hoshino = Repo.one(by_name.("Miyoko", "Hoshino"))
masaaki_tachibana = Repo.one(by_name.("Masaaki", "Tachibana"))
koji_uno = Repo.one(by_name.("Koji", "Uno"))
keiji_sakakida = Repo.one(by_name.("Keiji", "Sakakida"))
akira_sera = Repo.one(by_name.("Akira", "Sera"))
tadao_nakamaru = Repo.one(by_name.("Tadao", "Nakamaru"))

roles = [
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: hiroshi_koizumi.id,
    roles: ["Tsukioka"],
    order: 1
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: setsuko_wakayama.id,
    roles: ["Hidemi Yamaji"],
    order: 2
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: minoru_chiaki.id,
    roles: ["Kobayashi"],
    order: 3
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: takashi_shimura.id,
    roles: ["Dr. Kyohei Yamane"],
    order: 4
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: masao_shimizu.id,
    roles: ["Dr. Tadokoro"],
    order: 5
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: seijiro_onda.id,
    roles: ["Captain Terasawa"],
    order: 6
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: sonosuke_sawamura.id,
    roles: ["Hokkaido Branch Manager Shibeki"],
    order: 7
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: yoshio_tsuchiya.id,
    roles: ["Tajima"],
    order: 8
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: mayuri_mokusho.id,
    roles: ["Yasuko"],
    order: 9
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: minosuke_yamada.id,
    roles: ["Defense Secretary"],
    order: 10
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: yukio_kasama.id,
    roles: ["Mr. Yamaji"],
    order: 11
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: senkichi_omura.id,
    roles: ["Escaped Convict"],
    order: 12
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: ren_yamamoto.id,
    roles: ["Ikeda"],
    order: 13
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: shin_otomo.id,
    roles: ["Escaped Convict"],
    order: 14
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Fishing Company Employee"],
    order: 15
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: takeo_oikawa.id,
    roles: ["Police Chief"],
    order: 16
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: sokichi_maki.id,
    roles: ["Escaped Convict"],
    order: 17
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: shoichi_hirose.id,
    roles: ["Escaped Convict"],
    order: 18
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: junpei_natsuki.id,
    roles: ["Escaped Convict"],
    order: 20
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: katsumi_tezuka.id,
    roles: ["Anguirus"],
    order: 22
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: haruo_nakajima.id,
    roles: ["Godzilla"],
    order: 23
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: miyoko_hoshino.id,
    roles: ["Nightclub Singer"],
    order: 24
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: masaaki_tachibana.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: koji_uno.id,
    roles: ["Assistant"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: keiji_sakakida.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: akira_sera.id,
    roles: ["Fishing Company Employee"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_raids_again.id,
    person_id: tadao_nakamaru.id,
    roles: ["Policeman"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^godzilla_raids_again.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
