alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.ActorPersonRole

godzilla_1954 = Repo.one from f in Film, where: f.title == "Godzilla, King of the Monsters"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

akira_takarada = Repo.one(by_name.("Akira", "Takarada"))
momoko_kochi = Repo.one(by_name.("Momoko", "Kochi"))
akihiko_hirata = Repo.one(by_name.("Akihiko", "Hirata"))
takashi_shimura = Repo.one(by_name.("Takashi", "Shimura"))
fuyuki_murakami = Repo.one(by_name.("Fuyuki", "Murakami"))
sachio_sakai = Repo.one(by_name.("Sachio", "Sakai"))
toranosuke_ogawa = Repo.one(by_name.("Toranosuke", "Ogawa"))
ren_yamamoto = Repo.one(by_name.("Ren", "Yamamoto"))
kan_hayashi = Repo.one(by_name.("Kan", "Hayashi"))
seijiro_onda = Repo.one(by_name.("Seijiro", "Onda"))
takeo_oikawa = Repo.one(by_name.("Takeo", "Oikawa"))
keiji_sakakida = Repo.one(by_name.("Keiji", "Sakakida"))
toyoaki_suzuki = Repo.one(by_name.("Toyoaki", "Suzuki"))
kuninori_kodo = Repo.one(by_name.("Kuninori", "Kodo"))
kin_sugai = Repo.one(by_name.("Kin", "Sugai"))
shizuko_azuma = Repo.one(by_name.("Shizuko", "Azuma"))
tadashi_okabe = Repo.one(by_name.("Tadashi", "Okabe"))
kiyoshi_kimata = Repo.one(by_name.("Kiyoshi", "Kimata"))
ren_imaizumi = Repo.one(by_name.("Ren", "Imaizumi"))
masaaki_tachibana = Repo.one(by_name.("Masaaki", "Tachibana"))
yasuhisa_tsutsumi = Repo.one(by_name.("Yasuhisa", "Tsutsumi"))
saburo_iketani = Repo.one(by_name.("Saburo", "Iketani"))
katsumi_tezuka = Repo.one(by_name.("Katsumi", "Tezuka"))
haruo_nakajima = Repo.one(by_name.("Haruo", "Nakajima"))
yutaka_sada = Repo.one(by_name.("Yutaka", "Sada"))
takuzo_kumagai = Repo.one(by_name.("Takuzo", "Kumagai"))
yu_fujiki = Repo.one(by_name.("Yu", "Fujiki"))
shoichi_hirose = Repo.one(by_name.("Shoichi", "Hirose"))
sokichi_maki = Repo.one(by_name.("Sokichi", "Maki"))
junpei_natsuki = Repo.one(by_name.("Junpei", "Natsuki"))
junichiro_mukai = Repo.one(by_name.("Junichiro", "Mukai"))
kamayuki_tsubono = Repo.one(by_name.("Kamayuki", "Tsubono"))
kazuo_hinata = Repo.one(by_name.("Kazuo", "Hinata"))
ken_echigo = Repo.one(by_name.("Ken", "Echigo"))
kenji_sahara = Repo.one(by_name.("Kenji", "Sahara"))
koji_uno = Repo.one(by_name.("Koji", "Uno"))
mitsuo_tsuda = Repo.one(by_name.("Mitsuo", "Tsuda"))
rinsaku_ogata = Repo.one(by_name.("Rinsaku", "Ogata"))
akira_sera = Repo.one(by_name.("Akira", "Sera"))
hideo_shibuya = Repo.one(by_name.("Hideo", "Shibuya"))

roles = [
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: akira_takarada.id,
    roles: ["Hideto Ogata"],
    order: 1
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: momoko_kochi.id,
    roles: ["Emiko Yamane"],
    order: 2
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: akihiko_hirata.id,
    roles: ["Dr. Daisuke Serizawa"],
    order: 3
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: takashi_shimura.id,
    roles: ["Dr. Kyohei Yamane"],
    order: 4
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: fuyuki_murakami.id,
    roles: ["Dr. Tanabe"],
    order: 5
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: sachio_sakai.id,
    roles: ["Hagiwara"],
    order: 6
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: toranosuke_ogawa.id,
    roles: ["Fishing Company President"],
    order: 7
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: ren_yamamoto.id,
    roles: ["Masaji"],
    order: 8
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: kan_hayashi.id,
    roles: ["Diet Chairman"],
    order: 9
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: seijiro_onda.id,
    roles: ["Parliamentarian"],
    order: 10
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: takeo_oikawa.id,
    roles: ["Defense Secretary"],
    order: 11
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: keiji_sakakida.id,
    roles: ["Mayor Inada"],
    order: 12
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: toyoaki_suzuki.id,
    roles: ["Shinkichi"],
    order: 13
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: kuninori_kodo.id,
    roles: ["Izuma"],
    order: 14
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: kin_sugai.id,
    roles: ["Parliamentarian"],
    order: 15
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: shizuko_azuma.id,
    roles: ["Cruise Passenger"],
    order: 17
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: tadashi_okabe.id,
    roles: ["Yamane's Assistant"],
    order: 19
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: kiyoshi_kimata.id,
    roles: ["Cruise Passenger"],
    order: 20
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: ren_imaizumi.id,
    roles: ["Coast Guard"],
    order: 21
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: masaaki_tachibana.id,
    roles: ["Doomed Reporter"],
    order: 22
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: yasuhisa_tsutsumi.id,
    roles: ["Islander"],
    order: 24
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: saburo_iketani.id,
    roles: ["Reporter"],
    order: 26
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: katsumi_tezuka.id,
    roles: ["Newspaper Editor", "Godzilla"],
    order: 27
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: haruo_nakajima.id,
    roles: ["Newspaper Reporter", "Godzilla"],
    order: 28
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: yutaka_sada.id,
    roles: ["Defense Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: takuzo_kumagai.id,
    roles: ["Defense Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: yu_fujiki.id,
    roles: ["Ship's Radio Operator"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: shoichi_hirose.id,
    roles: ["Parliamentarian"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: sokichi_maki.id,
    roles: ["Coast Guard"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: junpei_natsuki.id,
    roles: ["Substation Operator"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: junichiro_mukai.id,
    roles: ["Defense Official", "Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: kamayuki_tsubono.id,
    roles: ["Coast Guard"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: kazuo_hinata.id,
    roles: ["Defense Official"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: ken_echigo.id,
    roles: ["Sailor"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: kenji_sahara.id,
    roles: ["Cruise Passenger", "Reporter"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: koji_uno.id,
    roles: ["Correspondent"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: mitsuo_tsuda.id,
    roles: ["Policeman"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: rinsaku_ogata.id,
    roles: ["Radio Operator"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: akira_sera.id,
    roles: ["Parliamentarian"],
    order: 99
  },
  %ActorPersonRole{
    film_id: godzilla_1954.id,
    person_id: hideo_shibuya.id,
    roles: ["Reporter"],
    order: 99
  }
]

from(role in ActorPersonRole, where: role.film_id == ^godzilla_1954.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
