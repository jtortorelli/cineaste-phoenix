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
alias Cineaste.Repo
alias Cineaste.Film

Repo.delete_all Film

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
    id: "b830207e-f26a-428a-af20-6ef4f33a7e79",
    title: "Godzilla's Revenge",
    release_date: %Ecto.Date{year: 1969, month: 12, day: 20},
    duration: 70,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#12539;&#12511;&#12491;&#12521;&#12539;&#12460;&#12496;&#12521; &#12458;&#12540;&#12523;&#24618;&#29539;&#22823;&#36914;&#25731;",
    original_transliteration: "Gojira Minira Gabara Ooru Kaijyuu Daishingeki",
    original_translation: "Gojira Minya Gabara All Monster Big Attack",
    aliases: ["All Monsters Attack"]
    },
  %Film{
    id: "5e1e2305-33c3-4099-9df0-8aedc8ade27e",
    title: "Godzilla vs. the Smog Monster",
    release_date: %Ecto.Date{year: 1971, month: 7, day: 24},
    duration: 85,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#23550;&#12504;&#12489;&#12521;",
    original_transliteration: "Gojira Tai Hedora",
    original_translation: "Godzilla Against Hedorah",
    aliases: ["Godzilla vs. Hedorah"]
    },
  %Film{
    id: "343092d6-ada8-460a-a8c9-94253fdde644",
    title: "Godzilla on Monster Island",
    release_date: %Ecto.Date{year: 1972, month: 3, day: 12},
    duration: 89,
    showcase: true,
    original_title: "&#22320;&#29699;&#25915;&#25731;&#21629;&#20196; &#12468;&#12472;&#12521;&#23550;&#12460;&#12452;&#12460;&#12531;",
    original_transliteration: "Chikyuu Kougeki Meirei Gojira Tai Gaigan",
    original_translation: "Earth Destruction Order Gojira Against Gigan",
    aliases: ["Godzilla vs. Gigan"]
    },
  %Film{
    id: "25b92b7d-066e-4cbb-889b-f40938798176",
    title: "Godzilla vs. Megalon",
    release_date: %Ecto.Date{year: 1973, month: 3, day: 17},
    duration: 82,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#23550;&#12513;&#12460;&#12525;",
    original_transliteration: "Gojira Tai Megaro",
    original_translation: "Godzilla Against Megalon"
    },
  %Film{
    id: "7fa08a1a-ab1a-4a6b-b205-280a75d3f6f2",
    title: "Godzilla vs. the Cosmic Monster",
    release_date: %Ecto.Date{year: 1974, month: 3, day: 21},
    duration: 84,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#23550;&#12513;&#12459;&#12468;&#12472;&#12521;",
    original_transliteration: "Gojira Tai Mekagojira",
    original_translation: "Godzilla Against Mechagodzilla",
    aliases: ["Godzilla vs. the Bionic Monster", "Godzilla vs. Mechagodzilla"]
    },
  %Film{
    id: "231ac03e-9ce2-4736-8721-25818881b373",
    title: "Terror of Mechagodzilla",
    release_date: %Ecto.Date{year: 1975, month: 3, day: 15},
    duration: 83,
    showcase: true,
    original_title: "&#12513;&#12459;&#12468;&#12472;&#12521;&#12398;&#36870;&#35186;",
    original_transliteration: "Mekagojira No Gyakushyuu",
    original_translation: "Counterattack of Mechagodzilla",
    aliases: ["Terror of Godzilla"]
    },
  %Film{
    id: "1af772fd-8e12-4622-baea-7889ff85a20f",
    title: "The Return of Godzilla",
    release_date: %Ecto.Date{year: 1984, month: 12, day: 15},
    duration: 103,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;",
    original_transliteration: "Gojira",
    original_translation: "Godzilla",
    aliases: ["Godzilla 1985"]
    },
  %Film{
    id: "13b29b5d-df58-4fef-9d32-6aed104884a6",
    title: "Godzilla VS Biollante",
    release_date: %Ecto.Date{year: 1989, month: 12, day: 16},
    duration: 105,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;vs&#12499;&#12458;&#12521;&#12531;&#12486;",
    original_transliteration: "Gojira vs Biorante",
    original_translation: "Godzilla vs Biollante"
    },
  %Film{
    id: "5c897bc0-ffc2-46b5-8264-6cf3e18d1dbc",
    title: "Godzilla VS King Ghidorah",
    release_date: %Ecto.Date{year: 1991, month: 12, day: 14},
    duration: 103,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;vs&#12461;&#12531;&#12464;&#12462;&#12489;&#12521;",
    original_transliteration: "Gojira vs Kingugidora",
    original_translation: "Godzilla vs King Ghidorah"
    },
  %Film{
    id: "7df60442-3bf6-449f-a94f-ec2f1a76bee6",
    title: "Godzilla VS Mothra",
    release_date: %Ecto.Date{year: 1992, month: 12, day: 12},
    duration: 102,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;vs&#12514;&#12473;&#12521;",
    original_transliteration: "Gojira vs Mosura",
    original_translation: "Godzilla vs Mothra",
    aliases: ["Godzilla and Mothra: The Battle for Earth"]
    },
  %Film{
    id: "2f2f94f8-dcc3-4130-9e30-f6b20b830765",
    title: "Godzilla VS Mechagodzilla",
    release_date: %Ecto.Date{year: 1993, month: 12, day: 11},
    duration: 108,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;vs&#12513;&#12459;&#12468;&#12472;&#12521;",
    original_transliteration: "Gojira vs Mekagojira",
    original_translation: "Godzilla vs Mechagodzilla",
    aliases: ["Godzilla vs. Mechagodzilla II"]
    },
  %Film{
    id: "00972f17-52f8-441b-8df4-66865aa1848e",
    title: "Godzilla VS Space Godzilla",
    release_date: %Ecto.Date{year: 1994, month: 12, day: 10},
    duration: 108,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;vs&#12473;&#12506;&#12540;&#12473;&#12468;&#12472;&#12521;",
    original_transliteration: "Gojira vs Supeesugojira",
    original_translation: "Godzilla vs Space Godzilla",
    aliases: ["Godzilla vs. SpaceGodzilla"]
    },
  %Film{
    id: "9edc3040-0295-494f-ac73-93b257d39d16",
    title: "Godzilla VS Destroyer",
    release_date: %Ecto.Date{year: 1995, month: 12, day: 9},
    duration: 103,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;vs&#12487;&#12473;&#12488;&#12525;&#12452;&#12450;",
    original_transliteration: "Gojira vs Desutoroia",
    original_translation: "Godzilla vs Destroyer",
    aliases: ["Godzilla vs. Destoroyah"]
    },
  %Film{
    id: "e20b47c9-093f-4578-a6ba-847f7294851e",
    title: "Godzilla 2000",
    release_date: %Ecto.Date{year: 1999, month: 12, day: 11},
    duration: 108,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;2000 &#12511;&#12524;&#12491;&#12450;&#12512;",
    original_transliteration: "Gojira Nisen Mireniamu",
    original_translation: "Godzilla 2000 Millennium"
    },
  %Film{
    id: "1a281844-49ca-4634-a9e4-b9081cbd56d7",
    title: "Godzilla X Megaguirus",
    release_date: %Ecto.Date{year: 2000, month: 12, day: 16},
    duration: 105,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#215;&#12513;&#12460;&#12462;&#12521;&#12473; G&#28040;&#28357;&#20316;&#25126;",
    original_transliteration: "Gojira x Megagirasu G Shyoumetsu Sakusen",
    original_translation: "Godzilla x Megaguirus G Elimination Strategy",
    aliases: ["Godzilla vs. Megaguirus"]
    },
  %Film{
    id: "fe388323-84d4-4aea-bf63-d4c07c373792",
    title: "GMK",
    release_date: %Ecto.Date{year: 2001, month: 12, day: 15},
    duration: 105,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#12539;&#12514;&#12473;&#12521;&#12539;&#12461;&#12531;&#12464;&#12462;&#12489;&#12521; &#22823;&#24618;&#29539;&#32207;&#25915;&#25731;",
    original_transliteration: "Gojira Mosura Kingugidora Daikaijyuu Soukougeki",
    original_translation: "Godzilla Mothra King Ghidorah Giant Monsters All-Out Attack"
    },
  %Film{
    id: "02d8c055-72de-4801-9faf-20a5dbcf903c",
    title: "Godzilla X Mechagodzilla",
    release_date: %Ecto.Date{year: 2002, month: 12, day: 14},
    duration: 88,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#215;&#12513;&#12459;&#12468;&#12472;&#12521;",
    original_transliteration: "Gojira x Mekagojira",
    original_translation: "Godzilla x Mechagodzilla",
    aliases: ["Godzilla Against Mechagodzilla"]
    },
  %Film{
    id: "8bffd0ae-a45f-40c8-b7ba-3cb3891735a2",
    title: "Godzilla X Mothra X Mechagodzilla: Tokyo SOS",
    release_date: %Ecto.Date{year: 2003, month: 12, day: 13},
    duration: 91,
    showcase: true,
    original_title: "&#12468;&#12472;&#12521;&#215;&#12514;&#12473;&#12521;&#215;&#12513;&#12459;&#12468;&#12472;&#12521; &#26481;&#20140;SOS",
    original_transliteration: "Gojira x Mosura x Mekagojira Toukyou SOS",
    original_translation: "Godzilla x Mothra x Mechagodzilla Tokyo SOS",
    aliases: ["Godzilla: Tokyo SOS"]
    },
  %Film{
    id: "b4c56cda-b1a1-4bd9-ba94-30a84f0558f5",
    title: "Godzilla: Final Wars",
    release_date: %Ecto.Date{year: 2004, month: 12, day: 4},
    duration: 125,
    showcase: true,
    },
  %Film{
    id: "3ef12fcb-7ff7-4607-9690-266936c0da14",
    title: "Shin Godzilla",
    release_date: %Ecto.Date{year: 2016, month: 7, day: 29},
    duration: 120,
    showcase: true,
    original_title: "&#12471;&#12531;&#12539;&#12468;&#12472;&#12521;",
    original_transliteration: "Shin Gojira",
    original_translation: "Shin Godzilla",
    aliases: ["Godzilla Resurgence"]
    }
]

Enum.each(films, fn x -> Repo.insert! x end)
