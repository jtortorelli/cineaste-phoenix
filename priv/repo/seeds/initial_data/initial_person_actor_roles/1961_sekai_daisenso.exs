alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

last_war = Repo.one from f in Film, where: f.title == "The Last War"

by_name = fn(given_name, family_name) ->
  person = Repo.one from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
  if is_nil(person) do
    raise "#{given_name} #{family_name} not found"
  else
    person
  end
end

frankie_sakai = by_name.("Frankie", "Sakai")
akira_takarada = by_name.("Akira", "Takarada")
yuriko_hoshi = by_name.("Yuriko", "Hoshi")
nobuko_otowa = by_name.("Nobuko", "Otowa")
yumi_shirakawa = by_name.("Yumi", "Shirakawa")
chishu_ryu = by_name.("Chishu", "Ryu")
jerry_ito = by_name.("Jerry", "Ito")
eijiro_tono = by_name.("Eijiro", "Tono")
so_yamamura = by_name.("So", "Yamamura")
ken_uehara = by_name.("Ken", "Uehara")
seizaburo_kawazu = by_name.("Seizaburo", "Kawazu")
nobuo_nakamura = by_name.("Nobuo", "Nakamura")
chieko_nakakita = by_name.("Chieko", "Nakakita")
minoru_takada = by_name.("Minoru", "Takada")
shigeki_ishida = by_name.("Shigeki", "Ishida")
kozo_nomura = by_name.("Kozo", "Nomura")
yutaka_sada = by_name.("Yutaka", "Sada")
nadao_kirino = by_name.("Nadao", "Kirino")
koji_uno = by_name.("Koji", "Uno")
takuzo_kumagai = by_name.("Takuzo", "Kumagai")
soji_ubukata = by_name.("Soji", "Ubukata")
shiro_tsuchiya = by_name.("Shiro", "Tsuchiya")
naoya_kusakawa = by_name.("Naoya", "Kusakawa")
wataru_omae = by_name.("Wataru", "Omae")
yoshio_katsube = by_name.("Yoshio", "Katsube")
masaki_shinohara = by_name.("Masaki", "Shinohara")
yutaka_oka = by_name.("Yutaka", "Oka")
harold_conway = by_name.("Harold", "Conway")
osman_yusef = by_name.("Osman", "Yusef")
hiroshi_sekida = by_name.("Hiroshi", "Sekida")
obel_wyatt = by_name.("Obel", "Wyatt")
saburo_iketani = by_name.("Saburo", "Iketani")
masanari_nihei = by_name.("Masanari", "Nihei")
ken_echigo = by_name.("Ken", "Echigo")
kamayuki_tsubono = by_name.("Kamayuki", "Tsubono")
kazuo_hinata = by_name.("Kazuo", "Hinata")
masaaki_tachibana = by_name.("Masaaki", "Tachibana")
akio_kusama = by_name.("Akio", "Kusama")
haruo_suzuki = by_name.("Haruo", "Suzuki")
hideo_shibuya = by_name.("Hideo", "Shibuya")

roles = [
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: frankie_sakai.id,
    roles: ["Mokichi Tamura"],
    order: 1
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: akira_takarada.id,
    roles: ["Takano"],
    order: 2
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: yuriko_hoshi.id,
    roles: ["Saeko Tamura"],
    order: 3
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: nobuko_otowa.id,
    roles: ["Yoshi Tamura"],
    order: 4
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: yumi_shirakawa.id,
    roles: ["Sanae Ebara"],
    order: 5
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: chishu_ryu.id,
    roles: ["Ebara"],
    order: 6
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: jerry_ito.id,
    roles: ["Watkins"],
    order: 7
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: eijiro_tono.id,
    roles: ["Takano's Captain"],
    order: 8
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: so_yamamura.id,
    roles: ["Prime Minister"],
    order: 9
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: ken_uehara.id,
    roles: ["Minister"],
    order: 10
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: seizaburo_kawazu.id,
    roles: ["Minister"],
    order: 11
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: nobuo_nakamura.id,
    roles: ["Cabinet Secretary"],
    order: 12
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: chieko_nakakita.id,
    roles: ["Ohara"],
    order: 13
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: minoru_takada.id,
    roles: ["Missile Defense Officer"],
    order: 14
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: shigeki_ishida.id,
    roles: ["Press Club Chauffeur"],
    order: 15
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: kozo_nomura.id,
    roles: ["Tamura's Stock Broker"],
    order: 17
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: yutaka_sada.id,
    roles: ["Reporter"],
    order: 19
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: nadao_kirino.id,
    roles: ["Missile Defense Officer"],
    order: 20
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: koji_uno.id,
    roles: ["Defense Officer"],
    order: 21
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: takuzo_kumagai.id,
    roles: ["Minister"],
    order: 26
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: soji_ubukata.id,
    roles: ["Minister"],
    order: 27
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: shiro_tsuchiya.id,
    roles: ["Minister"],
    order: 28
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: naoya_kusakawa.id,
    roles: ["Helicopter Crew"],
    order: 30
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: wataru_omae.id,
    roles: ["Sailor"],
    order: 31
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: yoshio_katsube.id,
    roles: ["Reporter"],
    order: 32
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: masaki_shinohara.id,
    roles: ["Defense Crew"],
    order: 33
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: yutaka_oka.id,
    roles: ["Defense Crew"],
    order: 34
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: harold_conway.id,
    roles: ["Federation Missile Commander"],
    order: 52
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: osman_yusef.id,
    roles: ["Alliance Pilot"],
    order: 53
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: hiroshi_sekida.id,
    roles: ["TV Singer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: obel_wyatt.id,
    roles: ["Alliance Officer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: saburo_iketani.id,
    roles: ["TV Announcer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: masanari_nihei.id,
    roles: ["TV Singer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: ken_echigo.id,
    roles: ["TV Singer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Press Club Chauffeur"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: kazuo_hinata.id,
    roles: ["Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: masaaki_tachibana.id,
    roles: ["Reporter", "Security Guard"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: akio_kusama.id,
    roles: ["Press Club Chauffeur"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: haruo_suzuki.id,
    roles: ["Defense Officer"],
    order: 99
  },
  %ActorPersonRole{
    film_id: last_war.id,
    person_id: hideo_shibuya.id,
    roles: ["Sailor"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^last_war.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
