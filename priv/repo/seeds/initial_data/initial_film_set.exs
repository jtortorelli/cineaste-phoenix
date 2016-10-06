# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cineaste.Repo.insert!(%Cineaste.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film

films = [
  %Film{
    id: "653335e2-101e-4303-90a2-eb71dac3c6e3",
    title: "Godzilla, King of the Monsters",
    release_date: %Ecto.Date{year: 1954, month: 11, day: 3},
    duration: 97,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;",
    original_transliteration: "Gojira",
    original_translation: "Godzilla",
    aliases: ["Godzilla"]
    },
  %Film{
    id: "7f9c68a7-8cec-4f4e-be97-528fe66605c3",
    title: "Godzilla Raids Again",
    release_date: %Ecto.Date{year: 1955, month: 4, day: 24},
    duration: 82,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#12398;&#36870;&#35186;",
    original_transliteration: "Gojira No Gyakushyuu",
    original_translation: "Counterattack of Godzilla",
    aliases: ["Gigantis, the Fire Monster"]
    },
  %Film{
    id: "d6a05fe9-ea91-4b75-a04a-77c8217a56cd",
    title: "King Kong vs. Godzilla",
    release_date: %Ecto.Date{year: 1962, month: 8, day: 11},
    duration: 97,
    showcase: true,
    original_title: "&#12461;&#12531;&#12464;&#12467;&#12531;&#12464;&#23550;&#12468;&#12472;&#12521;",
    original_transliteration: "Kingukongu Tai Gojira",
    original_translation: "King Kong Against Godzilla"
    },
  %Film{
    id: "75bb901c-e41c-494f-aae8-7a5282f3bf96",
    title: "Mothra vs. Godzilla",
    release_date: %Ecto.Date{year: 1964, month: 4, day: 29},
    duration: 89,
    showcase: true,
    original_title: "&#12514;&#12473;&#12521;&#23550;&#12468;&#12472;&#12521;",
    original_transliteration: "Mosura Tai Gojira",
    original_translation: "Mothra Against Godzilla",
    aliases: ["Godzilla vs. the Thing"]
    },
  %Film{
    id: "2f761ce5-34ae-4e7e-8ce0-90fec7f94f68",
    title: "Ghidorah, the Three-Headed Monster",
    release_date: %Ecto.Date{year: 1964, month: 12, day: 20},
    duration: 93,
    showcase: true,
    original_title: "&#19977;&#22823;&#24618;&#29539; &#22320;&#29699;&#26368;&#22823;&#12398;&#27770;&#25126;",
    original_transliteration: "San Daikaijyuu Chikyuu Saidai No Kessen",
    original_translation: "Three Giant Monsters Greatest Battle of Earth",
    aliases: ["Ghidrah, the Three-Headed Monster"]
    },
  %Film{
    id: "0a2401ee-c5da-4e00-a2bc-d6ae7026aa13",
    title: "Monster Zero",
    release_date: %Ecto.Date{year: 1965, month: 12, day: 19},
    duration: 94,
    showcase: true,
    original_title: "&#24618;&#29539;&#22823;&#25126;&#20105;",
    original_transliteration: "Kaijyuu Daisensou",
    original_translation: "Monster Great War",
    aliases: ["Godzilla vs. Monster Zero", "Invasion of Astro-Monster"]
    },
  %Film{
    id: "f474852a-cc25-477d-a7b9-06aa688f7fb2",
    title: "Godzilla vs. the Sea Monster",
    release_date: %Ecto.Date{year: 1966, month: 12, day: 17},
    duration: 87,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#12539;&#12456;&#12499;&#12521;&#12539;&#12514;&#12473;&#12521;",
    original_transliteration: "Gojira Ebira Mosura Nankai No Daikettou",
    original_translation: "Godzilla Ebirah Mothra South Seas Great Duel",
    aliases: ["Ebirah, Horror of the Deep"]
    },
  %Film{
    id: "40cb6fad-15b4-46f5-8066-273cb965c3c4",
    title: "Son of Godzilla",
    release_date: %Ecto.Date{year: 1967, month: 12, day: 16},
    duration: 86,
    showcase: true,
    original_title: "&#24618;&#29539;&#23798;&#12398;&#27770;&#25126; &#12468;&#12472;&#12521;&#12398;&#24687;&#23376;",
    original_transliteration: "Kaijyuutou No Kessen Gojira No Musuko",
    original_translation: "Battle of Monster Island Son of Godzilla"
    },
  %Film{
    id: "7be35dd2-8758-4cb8-85af-17985772d431",
    title: "Destroy All Monsters",
    release_date: %Ecto.Date{year: 1968, month: 8, day: 1},
    duration: 89,
    showcase: true,
    original_title: "&#24618;&#29539;&#32207;&#36914;&#25731;",
    original_transliteration: "Kaijyuu Soushingeki",
    original_translation: "Monster Marching Attack"
    },
  %Film{
    id: "79a16ff9-c72a-4dd0-ba4e-67f578e97682",
    title: "The Invisible Man",
    release_date: %Ecto.Date{year: 1954, month: 12, day: 29},
    duration: 70,
    showcase: true,
    original_title: "&#36879;&#26126;&#20154;&#38291;",
    original_transliteration: "Toumei Ningen",
    original_translation: "Invisible Man"
    },
  %Film{
    id: "56dab76c-fc4d-4547-b2fe-3a743154f1d5",
    title: "Rodan",
    release_date: %Ecto.Date{year: 1956, month: 12, day: 26},
    duration: 82,
    showcase: true,
    original_title: "&#31354;&#12398;&#22823;&#24618;&#29539;&#12521;&#12489;&#12531;",
    original_transliteration: "Sora no Daikaijyuu Radon",
    original_translation: "Giant Monster of Sky Rodan"
    },
  %Film{
    id: "ef4f2354-b764-4f5e-af66-813369a2520c",
    title: "The Mysterians",
    release_date: %Ecto.Date{year: 1957, month: 12, day: 28},
    duration: 88,
    showcase: true,
    original_title: "&#22320;&#29699;&#38450;&#34907;&#36557;",
    original_transliteration: "Chikyuu Boueigun",
    original_translation: "Earth Defense Force"
    },
  %Film{
    id: "132ec70b-0248-450e-9ae2-38c8245dc2e9",
    title: "The H-Man",
    release_date: %Ecto.Date{year: 1958, month: 6, day: 24},
    duration: 87,
    showcase: true,
    original_title: "&#32654;&#22899;&#12392;&#28082;&#20307;&#20154;&#38291;",
    original_transliteration: "Bijyo To Ekitainingen",
    original_translation: "Beauty and Liquid Man"
    },
  %Film{
    id: "dbf96f34-252e-4cbb-bc3d-e7f74e8abea9",
    title: "Varan the Unbelievable",
    release_date: %Ecto.Date{year: 1958, month: 10, day: 14},
    duration: 82,
    showcase: true,
    original_title: "&#22823;&#24618;&#29539;&#12496;&#12521;&#12531;",
    original_transliteration: "Daikaijyuu Baran",
    original_translation: "Giant Monster Varan"
    },
  %Film{
    id: "0a158e9d-6e48-4b6e-9674-862d952fb3ab",
    title: "The Birth of Japan",
    release_date: %Ecto.Date{year: 1959, month: 10, day: 25},
    duration: 182,
    showcase: true,
    original_title: "&#26085;&#26412;&#35477;&#29983;",
    original_transliteration: "Nihon Tanjyou",
    original_translation: "Birth of Japan",
    aliases: ["The Three Treasures"]
    },
  %Film{
    id: "b2f4de7f-2091-49d4-af3d-0a4ee1d9cd09",
    title: "Battle in Outer Space",
    release_date: %Ecto.Date{year: 1959, month: 12, day: 26},
    duration: 91,
    showcase: true,
    original_title: "&#23431;&#23449;&#22823;&#25126;&#20105;",
    original_transliteration: "Uchyuu Daisensou",
    original_translation: "Space Great War"
    },
  %Film{
    id: "249785ea-a53b-43e3-94d6-c5d2f2d833c4",
    title: "The Secret of the Telegian",
    release_date: %Ecto.Date{year: 1960, month: 4, day: 10},
    duration: 85,
    showcase: true,
    original_title: "&#38651;&#36865;&#20154;&#38291;",
    original_transliteration: "Densou Ningen",
    original_translation: "Electric Man"
    },
  %Film{
    id: "e8ccb201-e076-48cb-9307-f8b99101f133",
    title: "The Human Vapor",
    release_date: %Ecto.Date{year: 1960, month: 12, day: 11},
    duration: 91,
    showcase: true,
    original_title: "&#12460;&#12473;&#20154;&#38291;&#31532;&#19968;&#21495;",
    original_transliteration: "Gasu Ningen Dai Ichigou",
    original_translation: "Gas Man No. 1"
    },
  %Film{
    id: "a62c9a6b-aa36-4d5d-b869-2fc79efa28ab",
    title: "Mothra",
    release_date: %Ecto.Date{year: 1961, month: 7, day: 30},
    duration: 101,
    showcase: true,
    original_title: "&#12514;&#12473;&#12521;",
    original_transliteration: "Mosura",
    original_translation: "Mothra"
    },
  %Film{
    id: "9b724e83-39e6-4e57-b112-81e74d578ae0",
    title: "The Last War",
    release_date: %Ecto.Date{year: 1961, month: 10, day: 8},
    duration: 110,
    showcase: true,
    original_title: "&#19990;&#30028;&#22823;&#25126;&#20105;",
    original_transliteration: "Sekai Daisensou",
    original_translation: "World Great War"
    },
  %Film{
    id: "80731aaf-e8e4-4c5b-bd80-e033bd3a7daa",
    title: "Gorath",
    release_date: %Ecto.Date{year: 1962, month: 3, day: 21},
    duration: 88,
    showcase: true,
    original_title: "&#22934;&#26143;&#12468;&#12521;&#12473;",
    original_transliteration: "Yousei Gorasu",
    original_translation: "Mystery Planet Gorath"
    },
  %Film{
    id: "7df339b8-5cc8-4cfc-87a7-d8012c2a9916",
    title: "Matango",
    release_date: %Ecto.Date{year: 1963, month: 8, day: 11},
    duration: 89,
    showcase: true,
    original_title: "&#12510;&#12479;&#12531;&#12468;",
    original_transliteration: "Matango",
    original_translation: "Matango",
    aliases: ["Attack of the Mushroom People"]
    },
  %Film{
    id: "b30c5657-a980-489b-bd91-d58e63609102",
    title: "Samurai Pirate",
    release_date: %Ecto.Date{year: 1963, month: 10, day: 26},
    duration: 97,
    showcase: true,
    original_title: "&#22823;&#30423;&#36042;",
    original_transliteration: "Daitouzoku",
    original_translation: "Great Bandit",
    aliases: ["The Lost World of Sinbad"]
    },
  %Film{
    id: "5df297a2-5f6d-430d-b7fc-952e97ac9d79",
    title: "Atragon",
    release_date: %Ecto.Date{year: 1963, month: 12, day: 22},
    duration: 94,
    showcase: true,
    original_title: "&#28023;&#24213;&#36557;&#33382;",
    original_transliteration: "Kaitei Gunkan",
    original_translation: "Undersea Warship"
    },
  %Film{
    id: "700c2ce1-095e-48ac-96c0-1d31f0c4e52b",
    title: "Dogora, the Space Monster",
    release_date: %Ecto.Date{year: 1964, month: 8, day: 11},
    duration: 81,
    showcase: true,
    original_title: "&#23431;&#23449;&#22823;&#24618;&#29539;&#12489;&#12468;&#12521;",
    original_transliteration: "Uchyuu Daikaijyuu Dogora",
    original_translation: "Space Giant Monster Dogora",
    aliases: ["Dogora"]
    },
  %Film{
    id: "183fbe01-1bd2-4ade-b83b-6248ec7d7fee",
    title: "Frankenstein Conquers the World",
    release_date: %Ecto.Date{year: 1965, month: 8, day: 8},
    duration: 94,
    showcase: true,
    original_title: "&#12501;&#12521;&#12531;&#12465;&#12531;&#12471;&#12517;&#12479;&#12452;&#12531;&#23550;&#22320;&#24213;&#24618;&#29539;&#12496;&#12521;&#12468;&#12531;",
    original_transliteration: "Furankenshyutain Tai Chitei Kaijyuu Baragon",
    original_translation: "Frankenstein Against Underground Monster Baragon",
    aliases: ["Frankenstein vs. Baragon"]
    },
  %Film{
    id: "3b0b0351-0b4b-4ab1-a84e-6fc554c86a31",
    title: "The Adventure of Taklamakan",
    release_date: %Ecto.Date{year: 1966, month: 4, day: 28},
    duration: 100,
    showcase: true,
    original_title: "&#22855;&#24012;&#22478;&#12398;&#20882;&#38522;",
    original_transliteration: "Kiganjyou No Bouken",
    original_translation: "Adventure of Stone Castle",
    aliases: ["Adventure at Kiganjoh"]
    },
  %Film{
    id: "23c1c82e-aedb-4c9b-b040-c780eec577e8",
    title: "War of the Gargantuas",
    release_date: %Ecto.Date{year: 1966, month: 7, day: 31},
    duration: 88,
    showcase: true,
    original_title: "&#12501;&#12521;&#12531;&#12465;&#12531;&#12471;&#12517;&#12479;&#12452;&#12531;&#12398;&#24618;&#29539; &#12469;&#12531;&#12480;&#23550;&#12460;&#12452;&#12521;",
    original_transliteration: "Furankenshyutain no Kaijyuu Sanda Tai Gaira",
    original_translation: "Monsters of Frankenstein Sanda Against Gaira"
    },
  %Film{
    id: "ba6031ef-c7b0-451c-8465-cb2a3c494896",
    title: "King Kong Escapes",
    release_date: %Ecto.Date{year: 1967, month: 7, day: 22},
    duration: 104,
    showcase: true,
    original_title: "&#12461;&#12531;&#12464;&#12467;&#12531;&#12464;&#12398;&#36870;&#35186;",
    original_transliteration: "Kingukongu No Gyakushyuu",
    original_translation: "Counterattack of King Kong"
    }
]

ids = Enum.map(films, fn f -> f.id end)

from(film in Film, where: film.id in ^ids) |> Repo.delete_all

Enum.each(films, fn x -> Repo.insert! x end)
