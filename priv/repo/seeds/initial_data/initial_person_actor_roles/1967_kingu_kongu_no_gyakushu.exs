alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

king_kong_escapes = Repo.one from f in Film, where: f.title == "King Kong Escapes"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

akira_takarada = by_name.("Akira", "Takarada")
mie_hama = by_name.("Mie", "Hama")
rhodes_reason = by_name.("Rhodes", "Reason")
linda_miller = by_name.("Linda", "Miller")
hideyo_amamoto = by_name.("Hideyo", "Amamoto")
yoshibumi_tajima = by_name.("Yoshibumi", "Tajima")
sachio_sakai = by_name.("Sachio", "Sakai")
ikio_sawamura = by_name.("Ikio", "Sawamura")
nadao_kirino = by_name.("Nadao", "Kirino")
shoichi_hirose = by_name.("Shoichi", "Hirose")
kazuo_suzuki = by_name.("Kazuo", "Suzuki")
toru_ibuki = by_name.("Toru", "Ibuki")
naoya_kusakawa = by_name.("Naoya", "Kusakawa")
susumu_kurobe = by_name.("Susumu", "Kurobe")
haruo_nakajima = by_name.("Haruo", "Nakajima")
hiroshi_sekida = by_name.("Hiroshi", "Sekida")
shigeo_kato = by_name.("Shigeo", "Kato")
seishiro_kuno = by_name.("Seishiro", "Kuno")
tadashi_okabe = by_name.("Tadashi", "Okabe")
yoshio_katsube = by_name.("Yoshio", "Katsube")
yutaka_oka = by_name.("Yutaka", "Oka")
haruo_suzuki = by_name.("Haruo", "Suzuki")
haruya_sakamoto = by_name.("Haruya", "Sakamoto")
hideo_shibuya = by_name.("Hideo", "Shibuya")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
kazuo_hinata = by_name.("Kazuo", "Hinata")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
osman_yusef = by_name.("Osman", "Yusef")
rinsaku_ogata = by_name.("Rinsaku", "Ogata")
andrew_hughes = by_name.("Andrew", "Hughes")
akio_kusama = by_name.("Akio", "Kusama")

roles = [
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: akira_takarada.id,
    roles: ["Lt. Jiro Nomura"],
    order: 1
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: mie_hama.id,
    roles: ["Madame Piranha"],
    order: 2
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: rhodes_reason.id,
    roles: ["Carl Nelson"],
    order: 3
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: linda_miller.id,
    roles: ["Susan Watson"],
    order: 4
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: hideyo_amamoto.id,
    roles: ["Dr. Who"],
    order: 5
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: yoshibumi_tajima.id,
    roles: ["Who Henchman"],
    order: 6
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: sachio_sakai.id,
    roles: ["Who Henchman"],
    order: 7
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: ikio_sawamura.id,
    roles: ["Islander"],
    order: 9
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: nadao_kirino.id,
    roles: ["Who Henchman"],
    order: 10
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: shoichi_hirose.id,
    roles: ["Submarine Crew"],
    order: 11
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: kazuo_suzuki.id,
    roles: ["Who Henchman"],
    order: 12
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: toru_ibuki.id,
    roles: ["Who Henchman"],
    order: 13
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: naoya_kusakawa.id,
    roles: ["Who Henchman"],
    order: 14
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: susumu_kurobe.id,
    roles: ["Who Henchman"],
    order: 15
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: haruo_nakajima.id,
    roles: ["Bystander", "King Kong"],
    order: 16
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: hiroshi_sekida.id,
    roles: ["Gorosaurus", "Mechani-Kong"],
    order: 17
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: shigeo_kato.id,
    roles: ["Who Henchman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: seishiro_kuno.id,
    roles: ["Who Henchman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: tadashi_okabe.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: yoshio_katsube.id,
    roles: ["Who Henchman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: yutaka_oka.id,
    roles: ["Submarine Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: haruo_suzuki.id,
    roles: ["Who Henchman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: haruya_sakamoto.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: hideo_shibuya.id,
    roles: ["Submarine Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: kazuo_hinata.id,
    roles: ["Military Advisor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: masaaki_tachibana.id,
    roles: ["Soldier"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: osman_yusef.id,
    roles: ["Submarine Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: rinsaku_ogata.id,
    roles: ["Submarine Crew"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: andrew_hughes.id,
    roles: ["UN Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: king_kong_escapes.id,
    person_id: akio_kusama.id,
    roles: ["Soldier"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^king_kong_escapes.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
