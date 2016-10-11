alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Person

people = [
  %Person{
    id: "acace893-b445-4425-98d9-09126f7dcbf6",
    given_name: "Sokichi",
    family_name: "Maki",
    gender: "M",
    showcase: false,
    original_name: "&#29287; &#22766;&#21513;"
  },
  %Person{
    id: "c7826ac4-c962-4f2e-b62b-b0258eeadbee",
    given_name: "Kazuji",
    family_name: "Taira",
    gender: "M",
    showcase: false,
    original_name: "&#24179; &#19968;&#20108;"
  },
  %Person{
    id: "802c7416-8696-4075-a778-83314da7310d",
    given_name: "Masao",
    family_name: "Tamai",
    gender: "M",
    showcase: false,
    original_name: "&#29577;&#20117; &#27491;&#22827;",
    dob: %{year: 1908, month: 10, day: 3},
    dod: %{year: 1997, month: 5, day: 26},
    birth_place: "Matsuyama, Ehime, Japan"
  },
  %Person{
    id: "c70d0b2e-8511-4bfb-8527-808b3fef2a09",
    given_name: "Takeo",
    family_name: "Kita",
    gender: "M",
    showcase: false,
    original_name: "&#21271; &#29467;&#22827;",
    dob: %{year: 1901, month: 1, day: 9},
    dod: %{year: 1979, month: 9, day: 1},
    birth_place: "Osaka, Japan"
  },
  %Person{
    id: "6ad606bd-e3cb-45c2-b8a6-bb068854ffd7",
    given_name: "Hisashi",
    family_name: "Shimonaga",
    gender: "M",
    showcase: false,
    original_name: "&#19979;&#27704; &#23578;",
    dob: %{year: 1912, month: 12, day: 13},
    dod: %{year: 1998},
    birth_place: "Kumamoto, Japan"
  },
  %Person{
    id: "33c417fc-2635-4667-aaa7-feab79073d9d",
    given_name: "Choshiro",
    family_name: "Ishii",
    gender: "M",
    showcase: false,
    original_name: "&#30707;&#20117; &#38263;&#22235;&#37070;",
    dob: %{year: 1918, month: 6, day: 7},
    dod: %{year: 1983, month: 2, day: 26},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "84c442af-6bd6-4e53-93c6-f4b213175de4",
    given_name: "Takeo",
    family_name: "Murata",
    gender: "M",
    showcase: false,
    original_name: "&#26449;&#30000; &#27494;&#38596;",
    dob: %{year: 1907, month: 6, day: 17},
    dod: %{year: 1994, month: 7, day: 19},
    birth_place: "Shinagawa, Tokyo, Japan"
  },
  %Person{
    id: "ef73315d-624c-4436-a729-5e47d474365e",
    given_name: "Toranosuke",
    family_name: "Ogawa",
    gender: "M",
    showcase: false,
    original_name: "&#23567;&#24029; &#34382;&#20043;&#21161;",
    dob: %{year: 1897, month: 12, day: 1},
    dod: %{year: 1967, month: 12, day: 29},
    birth_place: "Akasuka, Tokyo, Japan",
    death_place: "Urawa, Saitama, Japan"
  },
  %Person{
    id: "97417c8f-8ba2-463d-a9d6-dac0810125be",
    given_name: "Kiyoshi",
    family_name: "Kimata",
    gender: "M",
    showcase: false,
    original_name: "&#40232;&#30000; &#28165;"
  },
  %Person{
    id: "7102d855-7fc6-4668-b20e-38fe1e3705cf",
    given_name: "Shizuko",
    family_name: "Azuma",
    gender: "F",
    showcase: false,
    original_name: "&#26481; &#38745;&#23376;",
    dob: %{year: 1930, month: 8, day: 22},
    dod: %{unknown: 1},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "daffb7f5-4b0c-4e00-96c4-6ac19b15d22b",
    given_name: "Kin",
    family_name: "Sugai",
    gender: "F",
    showcase: false,
    original_name: "&#33733;&#20117; &#12365;&#12435;",
    dob: %{year: 1928, month: 2, day: 28},
    birth_place: "Ushigome, Tokyo, Japan"
  },
  %Person{
    id: "0c704bd2-886c-4acc-8b83-f0b9b7ee8aac",
    given_name: "Toyoaki",
    family_name: "Suzuki",
    gender: "M",
    showcase: false,
    original_name: "&#37428;&#26408;&#35914;&#26126;"
  },
  %Person{
    id: "600f3ec6-2ba2-4c6d-8cc1-01f4d625755b",
    given_name: "Takeo",
    family_name: "Oikawa",
    gender: "M",
    showcase: false,
    original_name: "&#31496;&#24029;&#27494;&#22827;"
  },
  %Person{
    id: "f03e5540-5215-405b-8641-1b3f60ebe755",
    given_name: "Kan",
    family_name: "Hayashi",
    gender: "M",
    showcase: false,
    original_name: "&#26519; &#24185;",
    dob: %{year: 1894},
    dod: %{unknown: 1},
    birth_place: "Asakusa, Tokyo, Japan"
  },
  %Person{
    id: "3b4f6a36-44b7-4b23-af88-d03beec21e4d",
    given_name: "Masao",
    family_name: "Shimizu",
    gender: "M",
    showcase: false,
    original_name: "&#28165;&#27700; &#23558;&#22827;",
    dob: %{year: 1908, month: 10, day: 5},
    dod: %{year: 1975, month: 10, day: 5},
    birth_place: "Ushigome, Tokyo, Japan",
    death_place: "Shinjuku, Tokyo, Japan"
  },
  %Person{
    id: "3bd1857e-4894-4469-82da-e4f5f6c49a1a",
    given_name: "Miyoko",
    family_name: "Hoshino",
    gender: "F",
    showcase: false,
    original_name: "&#26143;&#37326; &#32654;&#20195;&#23376;"
  },
  %Person{
    id: "922bb3b7-bee1-45e6-bcd0-524336747977",
    given_name: "Mayuri",
    family_name: "Mokusho",
    gender: "F",
    showcase: false,
    original_name: "&#26408;&#21280; &#12510;&#12518;&#12522;",
    birth_name: "Kumiko Kitakumi (&#26408;&#21280; &#20037;&#32654;&#23376;)",
    dob: %{year: 1929, month: 10, day: 7},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "65abafc9-9dce-440e-adcf-cd8ae728c7eb",
    given_name: "Yukio",
    family_name: "Kasama",
    gender: "M",
    showcase: false,
    original_name: "&#31520;&#38291;&#38634;&#38596;"
  },
  %Person{
    id: "3ab19c1d-1525-46c0-a377-fe26be4e0950",
    given_name: "Seiichi",
    family_name: "Endo",
    gender: "M",
    showcase: false,
    original_name: "&#36960;&#34276;&#31934;&#19968;"
  },
  %Person{
    id: "177089db-5eef-4ab2-8d7a-cf11693545ca",
    given_name: "Masanobu",
    family_name: "Miyazaki",
    gender: "M",
    showcase: false,
    original_name: "&#23470;&#23822;&#27491;&#20449;"
  },
  %Person{
    id: "8bd05431-0f6f-47f7-b4c0-c928590e0f5d",
    given_name: "Masaki",
    family_name: "Onuma",
    gender: "M",
    showcase: false,
    original_name: "&#22823;&#27836;&#27491;&#21916;"
  },
  %Person{
    id: "914bfc59-ae69-495a-9a25-b1138de87bb0",
    given_name: "Shigeaki",
    family_name: "Hidaka",
    gender: "M",
    showcase: false,
    original_name: "&#26085;&#39640; &#32321;&#26126;",
    dob: %{year: 1916, month: 7, day: 30},
    birth_place: "Miyazaki, Japan"
  },
  %Person{
    id: "e12e2330-3a9a-489b-b6ed-7d9746a406d6",
    given_name: "Masao",
    family_name: "Fujiyoshi",
    gender: "M",
    showcase: false,
    original_name: "&#34276;&#22909; &#26124;&#29983;",
    dob: %{year: 1913},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "5d149a9f-cd4e-4b01-91e5-934200b5dcdb",
    given_name: "Teruaki",
    family_name: "Abe",
    gender: "M",
    showcase: false,
    original_name: "&#23433;&#20493;&#36637;&#26126;"
  },
  %Person{
    id: "90aad09a-2931-43e7-9f4d-1726e5f68685",
    given_name: "Hajime",
    family_name: "Koizumi",
    gender: "M",
    showcase: false,
    original_name: "&#23567;&#27849;&#19968;"
  },
  %Person{
    id: "28c62b3a-217d-4a2f-aab1-3fd7817bd189",
    given_name: "Reiko",
    family_name: "Kaneko",
    gender: "F",
    showcase: false,
    original_name: "&#20860;&#23376;&#29618;&#23376;"
  },
  %Person{
    id: "b8928aa8-991f-46b3-aca4-c72ba3656249",
    given_name: "Toshio",
    family_name: "Takashima",
    gender: "M",
    showcase: false,
    original_name: "&#39640;&#23798;&#21033;&#38596;"
  },
  %Person{
    id: "d559ba92-0eba-4724-b9f3-08371868d9db",
    given_name: "Douglas",
    family_name: "Fein",
    gender: "M",
    showcase: false,
    japanese_name: "&#12480;&#12464;&#12521;&#12473;&#12539;&#12501;&#12455;&#12540;&#12531;"
  },
  %Person{
    id: "8fbf0eb6-d46a-4f69-94ca-c3bfaf6b5e07",
    given_name: "Fumio",
    family_name: "Yanoguchi",
    gender: "M",
    showcase: false,
    original_name: "&#30690;&#37326;&#21475;&#25991;&#38596;"
  },
  %Person{
    id: "aa27cf6a-ae9a-4e2a-9921-a67f6b2f8184",
    given_name: "Ryohei",
    family_name: "Fujii",
    gender: "M",
    showcase: false,
    original_name: "&#34276;&#20117; &#33391;&#24179;"
  },
  %Person{
    id: "a7476494-4b15-4fd8-93b4-4548ed8f0086",
    given_name: "Shoshichi",
    family_name: "Kojima",
    gender: "M",
    showcase: false,
    original_name: "&#23567;&#23798;&#27491;&#19971;"
  },
  %Person{
    id: "e3ab3196-10d7-4e5e-83cd-2426353915bd",
    given_name: "Ichiya",
    family_name: "Aozora",
    gender: "M",
    showcase: false,
    original_name: "&#38738;&#31354; &#19968;&#22812;",
    birth_name: "Kihachiro Koitabashi (&#23567;&#26495;&#27211; &#21916;&#20843;&#37070;)",
    dob: %{year: 1932, month: 7, day: 17},
    dod: %{year: 1996, month: 4, day: 23},
    birth_place: "Tokura, Nagano, Japan"
  },
  %Person{
    id: "c765ae89-2193-4416-a9d8-7136589d618c",
    given_name: "Senya",
    family_name: "Aozora",
    gender: "M",
    showcase: false,
    original_name: "&#38738;&#31354; &#21315;&#22812;",
    birth_name: "Yoshihito Sakai (&#37202;&#20117; &#32681;&#20154;)",
    dob: %{year: 1930, month: 6, day: 28},
    dod: %{year: 1991, month: 6, day: 20},
    birth_place: "Kitakyushu, Fukuoka, Japan"
  },
  %Person{
    id: "d03c3fe8-39fa-4083-8e8a-85e033e6b92e",
    given_name: "Yuriko",
    family_name: "Hanabusa",
    gender: "F",
    showcase: false,
    original_name: "&#33521; &#30334;&#21512;&#23376;",
    birth_name: "Kesako Henmi (&#36920;&#35211; &#34952;&#35039;&#23376;)",
    dob: %{year: 1900, month: 3, day: 7},
    dod: %{year: 1970, month: 2, day: 7},
    birth_place: "Yoshiura, Hiroshima, Japan"
  },
  %Person{
    id: "6032ee2a-e49e-43be-b727-dfda0a12c60f",
    given_name: "Noriko",
    family_name: "Sengoku",
    gender: "F",
    showcase: false,
    original_name: "&#21315;&#30707; &#35215;&#23376;",
    dob: %{year: 1922, month: 4, day: 29},
    dod: %{year: 2012, month: 12, day: 27},
    birth_place: "Komazawa, Ebara, Tokyo, Japan"
  },
  %Person{
    id: "3b40b2fd-e981-4429-9a99-85cc2d357f50",
    given_name: "Wataru",
    family_name: "Konuma",
    gender: "M",
    showcase: false,
    original_name: "&#23567;&#27836;&#28193;"
  },
  %Person{
    id: "a536e565-3ef4-4187-87d7-7b064855fddd",
    given_name: "Toru",
    family_name: "Watanabe",
    gender: "M",
    showcase: false,
    original_name: "&#28193;&#36794; &#24505;"
  },
  %Person{
    id: "3df58f3a-039b-45ab-bf42-d842796cb7fe",
    given_name: "Kazuo",
    family_name: "Yamada",
    gender: "M",
    showcase: false,
    original_name: "&#23665;&#30000; &#19968;&#22827;",
    dob: %{year: 1919, month: 3, day: 25},
    dod: %{year: 2006, month: 1, day: 29},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "78f3b649-dfe7-49bc-aeb4-d4e02a28e67c",
    given_name: "Shoichi",
    family_name: "Yoshizawa",
    gender: "M",
    showcase: false,
    original_name: "&#21513;&#27810;&#26157;&#19968;"
  },
  %Person{
    id: "6afdc4fe-fec9-4640-9299-40d56e5fb25a",
    given_name: "Norikazu",
    family_name: "Onda",
    gender: "M",
    showcase: false,
    original_name: "&#38560;&#30000;&#32000;&#19968;"
  },
  %Person{
    id: "479f2ab3-c3c5-4049-8b4e-99367ceb893d",
    given_name: "Seiji",
    family_name: "Onaka",
    gender: "M",
    showcase: false,
    original_name: "&#22823;&#20210; &#28165;&#27835;",
    dob: %{year: 1934, month: 12, day: 15},
    birth_place: "Nara, Japan"
  },
  %Person{
    id: "b16d5b1e-8e3e-4814-9155-0a2eb9e06e3b",
    given_name: "Shin",
    family_name: "Watarai",
    gender: "M",
    showcase: false,
    original_name: "&#28193;&#20250; &#20280;",
    dob: %{year: 1918, month: 12, day: 13},
    dod: %{year: 2001, month: 5, day: 28},
    birth_place: "Odate, Akita, Japan"
  },
  %Person{
    id: "1c30afb0-3f4d-4017-84fd-cb68e9a2e6f0",
    given_name: "Toshiya",
    family_name: "Ban",
    gender: "M",
    showcase: false,
    original_name: "&#20276;&#21033;&#20063;"
  },
  %Person{
    id: "b9d6e433-dbac-4a1d-bb5b-1bdc316dfcb4",
    given_name: "Takeji",
    family_name: "Yamaguchi",
    gender: "G",
    showcase: false,
    original_name: "&#23665;&#21475;&#20553;&#27835;"
  },
  %Person{
    id: "475b78c0-45ad-46dc-8c99-b41a09ee2ec5",
    given_name: "Kazue",
    family_name: "Shiba",
    gender: "M",
    showcase: false,
    original_name: "&#26031;&#27874;&#19968;&#32117;"
  },
  %Person{
    id: "e0d84176-6d73-4185-919e-ddb1fb22f400",
    given_name: "Seiji",
    family_name: "Hirano",
    gender: "M",
    showcase: false,
    original_name: "&#24179;&#37326;&#28165;&#20037;"
  },
  %Person{
    id: "f8797cb2-6240-46d2-9772-5a58aeb0bc2e",
    given_name: "Taiichi",
    family_name: "Kankura",
    gender: "M",
    showcase: false,
    original_name: "&#23436;&#20489; &#27888;&#19968;",
    dob: %{year: 1912, month: 4, day: 30},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "5360ea2f-63f4-4453-9ffc-853586496732",
    given_name: "Teruo",
    family_name: "Aragaki",
    gender: "M",
    showcase: false,
    original_name: "&#33618;&#22435; &#36637;&#38596;"
  },
  %Person{
    id: "3dae06b9-b139-4c1d-b3db-e23ffe8d135c",
    given_name: "Susumu",
    family_name: "Utsumi",
    gender: "M",
    showcase: false,
    original_name: "&#20869;&#28023; &#36914;"
  },
  %Person{
    id: "1e6ae6ba-b28a-4a9b-97a9-2374c016d267",
    given_name: "Akio",
    family_name: "Kobori",
    gender: "M",
    showcase: false,
    original_name: "&#23567;&#22528;&#26126;&#30007;"
  },
  %Person{
    id: "46232c4d-423c-40eb-941d-087f6a1d0643",
    given_name: "Hideo",
    family_name: "Mihara",
    gender: "M",
    showcase: false,
    original_name: "&#20304;&#20271; &#31168;&#30007;",
    dob: %{year: 1912, month: 1, day: 9},
    dod: %{year: 2003, month: 11, day: 1},
    birth_place: "Asakasa, Tokyo, Japan",
    death_place: "Tokyo, Japan"
  },
  %Person{
    id: "d1e73155-2bf5-4378-929f-277d92e5e2ae",
    given_name: "Koichi",
    family_name: "Iwashita",
    gender: "M",
    showcase: false,
    original_name: "&#23721;&#19979; &#24195;&#19968;"
  },
  %Person{
    id: "730e679a-bb91-449b-86fb-3384fc4b9720",
    given_name: "Ken",
    family_name: "Kuronuma",
    gender: "M",
    showcase: false,
    original_name: "&#40658;&#27836; &#20581;",
    dob: %{year: 1902, month: 5, day: 1},
    dod: %{year: 1985, month: 7, day: 5},
    birth_place: "Yokohama, Kanagawa, Japan"
  },
  %Person{
    id: "5f8cfa7b-c504-4902-bd08-e030af359323",
    given_name: "Isamu",
    family_name: "Ashida",
    gender: "M",
    showcase: false,
    original_name: "&#33446;&#30000;&#21191;"
  },
  %Person{
    id: "e4fc3ee2-b54f-4ec0-8a84-64352507c5de",
    given_name: "Shigeru",
    family_name: "Mori",
    gender: "M",
    showcase: false,
    original_name: "&#26862;&#33538;"
  },
  %Person{
    id: "d031da60-ed80-44ee-b7e3-582c8d241aa6",
    given_name: "Kenichiro",
    family_name: "Tsunoda",
    gender: "M",
    showcase: false,
    original_name: "&#35282;&#30000; &#20581;&#19968;&#37070;",
    dob: %{year: 1919, month: 5, day: 20},
    dod: %{year: 1983, month: 8, day: 7}
  },
  %Person{
    id: "d99098d2-e43a-46a0-99aa-9458a2892bb1",
    given_name: "Norio",
    family_name: "Tone",
    gender: "M",
    showcase: false,
    original_name: "&#20992;&#26681;&#32000;&#38596;"
  },
  %Person{
    id: "79c3e233-566d-4d53-8fb0-87a1383ae3c8",
    given_name: "Kipp",
    family_name: "Hamilton",
    gender: "F",
    showcase: false,
    japanese_name: "&#12461;&#12483;&#12503;&#12539;&#12495;&#12511;&#12523;&#12488;&#12531;",
    birth_name: "Rita Marie Hamiton",
    dob: %{year: 1934, month: 8, day: 16},
    dod: %{year: 1981, month: 1, day: 29},
    birth_place: "Los Angeles, California, United States",
    death_place: "Los Angeles, California, United States"
  },
  %Person{
    id: "986d08ab-500a-4b71-a4e6-5cb2bcf6abb4",
    given_name: "Kuichiro",
    family_name: "Kishida",
    gender: "M",
    showcase: false,
    original_name: "&#23736;&#30000; &#20061;&#19968;&#37070;",
    dob: %{year: 1907, month: 1, day: 18},
    dod: %{year: 1996, month: 10, day: 28},
    birth_place: "Kyoto, Japan"
  },
  %Person{
    id: "8d818c87-fa3d-440c-9825-2def708d19cc",
    given_name: "Kiyoshi",
    family_name: "Shimizu",
    gender: "M",
    showcase: false,
    original_name: "&#28165;&#27700;&#21916;&#20195;&#24535;"
  },
  %Person{
    id: "08872122-2396-4e80-9a74-ef85447c4057",
    given_name: "Mitsuo",
    family_name: "Kaneko",
    gender: "M",
    showcase: false,
    original_name: "&#37329;&#23376;&#20809;&#30007;"
  },
  %Person{
    id: "00493c23-4851-4450-8d22-99eebd381727",
    given_name: "Shinichi",
    family_name: "Hoshi",
    gender: "M",
    showcase: false,
    original_name: "&#26143; &#26032;&#19968;",
    dob: %{year: 1926, month: 9, day: 26},
    dod: %{year: 1997, month: 12, day: 30},
    birth_place: "Akebono, Hongo, Tokyo, Japan",
    death_place: "Takanawa, Minato, Tokyo, Japan"
  },
  %Person{
    id: "48a7856e-e00d-410a-8dee-c9069575da5c",
    given_name: "Shigekazu",
    family_name: "Ikuno",
    gender: "M",
    showcase: false,
    original_name: "&#32946;&#37326; &#37325;&#19968;",
    dob: %{year: 1925, month: 1, day: 14},
    dod: %{year: 2003, month: 10, day: 26},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "b7285384-4240-4eaf-b9c0-ca8fcdc74233",
    given_name: "Sadao",
    family_name: "Bekku",
    gender: "M",
    showcase: false,
    original_name: "&#21029;&#23470; &#35998;&#38596;",
    dob: %{year: 1922, month: 5, day: 24},
    dod: %{year: 2012, month: 1, day: 12},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "1877d46d-9ace-4741-836c-0b03933c496d",
    given_name: "Masami",
    family_name: "Fukushima",
    gender: "M",
    showcase: false,
    original_name: "&#31119;&#23798; &#27491;&#23455;",
    dob: %{year: 1929, month: 2, day: 18},
    dod: %{year: 1976, month: 4, day: 9},
    birth_place: "Fengyuan, Sakhalin"
  },
  %Person{
    id: "6b8891db-a29b-4d5d-8635-c55f5c49e2ca",
    given_name: "Masanao",
    family_name: "Uehara",
    gender: "M",
    showcase: false,
    original_name: "&#19978;&#21407;&#27491;&#30452;"
  },
  %Person{
    id: "112a9c74-dd0f-4d1b-b020-18ad1062e48f",
    given_name: "Yasuyoshi",
    family_name: "Tajitsu",
    gender: "M",
    showcase: false,
    original_name: "&#30000;&#23455; &#27888;&#33391;",
    dob: %{year: 1925, month: 8, day: 19},
    dod: %{year: 1982, month: 6}
  },
  %Person{
    id: "8b35d3c7-019e-4371-b402-96f7c8cae0a9",
    given_name: "Peter",
    family_name: "Mann",
    gender: "M",
    showcase: false,
    japanese_name: "&#12500;&#12540;&#12479;&#12540;&#12539;&#12510;&#12531;"
  },
  %Person{
    id: "a37c4464-16f1-4754-b563-e247908a185c",
    given_name: "Hideo",
    family_name: "Unagami",
    gender: "M",
    showcase: false,
    original_name: "&#28023;&#19978; &#26085;&#20986;&#30007;"
  },
  %Person{
    id: "b4a497d1-74e0-4304-bc20-7a32275c73ab",
    given_name: "Tsuruzo",
    family_name: "Nishikawa",
    gender: "M",
    showcase: false,
    original_name: "&#35199;&#24029;&#40372;&#19977;"
  },
  %Person{
    id: "24651b22-cbb0-4472-9d73-c96ed96829d6",
    given_name: "Choshichiro",
    family_name: "Mikami",
    gender: "M",
    showcase: false,
    original_name: "&#19977;&#19978;&#38263;&#19971;&#37070;"
  },
  %Person{
    id: "387b5c1f-0e3a-4581-a4e1-26f64e412d52",
    given_name: "Jun",
    family_name: "Fujio",
    gender: "M",
    showcase: false,
    original_name: "&#34276;&#23614;&#32020;"
  },
  %Person{
    id: "c75a73c4-ed27-468e-b065-ff5a764f80e3",
    given_name: "Takehiko",
    family_name: "Fukunaga",
    gender: "M",
    showcase: false,
    original_name: "&#31119;&#27704; &#27494;&#24422;",
    dob: %{year: 1918, month: 3, day: 19},
    dod: %{year: 1979, month: 8, day: 13},
    birth_place: "Futsukaichi, Chikushi, Fukuoka, Japan",
    death_place: "Usuda, Minamisaku, Nagano, Japan"
  },
  %Person{
    id: "1009b31a-0266-4068-a9b8-f4b58d423490",
    given_name: "Shinichiro",
    family_name: "Nakamura",
    gender: "M",
    showcase: false,
    original_name: "&#20013;&#26449; &#30495;&#19968;&#37070;",
    dob: %{year: 1918, month: 3, day: 5},
    dod: %{year: 1997, month: 12, day: 25},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "07f8acfe-8d57-4c46-811c-8f499e27a989",
    given_name: "Shoichi",
    family_name: "Fujinawa",
    gender: "M",
    showcase: false,
    original_name: "&#34276;&#32260;&#27491;&#19968;"
  },
  %Person{
    id: "d7c89e93-28a0-4ac3-833f-fea8014e11f4",
    given_name: "Yoshie",
    family_name: "Hotta",
    gender: "F",
    showcase: false,
    original_name: "&#22528;&#30000; &#21892;&#34907;",
    dob: %{year: 1918, month: 7, day: 7},
    dod: %{year: 1998, month: 9, day: 5},
    birth_place: "Takaoka, Toyama, Japan"
  },
  %Person{
    id: "f31c5c90-46a9-46c7-a071-06efd3e4955a",
    given_name: "Leonard",
    family_name: "Stanford",
    gender: "M",
    showcase: false,
    japanese_name: "&#12524;&#12458;&#12490;&#12523;&#12489;&#12539;&#12473;&#12479;&#12531;&#12501;&#12457;&#12540;&#12489;"
  },
  %Person{
    id: "3c600a20-5a6b-4578-9943-3e8836dd14d3",
    given_name: "George",
    family_name: "Wyman",
    gender: "M",
    showcase: false,
    japanese_name: "&#12472;&#12519;&#12540;&#12472;&#12539;&#12527;&#12452;&#12510;&#12531;"
  },
  %Person{
    id: "18459827-37dc-45ae-b244-2ddeba4ed9e9",
    given_name: "Elise",
    family_name: "Richter",
    gender: "F",
    showcase: false,
    original_name: "&#12456;&#12522;&#12473;&#12539;&#12522;&#12463;&#12479;&#12540;"
  },
  %Person{
    id: "36e34390-71ca-4e42-a28e-e6944cc7d582",
    given_name: "Rokuro",
    family_name: "Ishikawa",
    gender: "M",
    showcase: false,
    original_name: "&#30707;&#24029;&#32209;&#37070;"
  },
  %Person{
    id: "d901ee22-34f3-4dc0-8c93-2362b57387a2",
    given_name: "Yo",
    family_name: "Shiomi",
    gender: "M",
    showcase: false,
    original_name: "&#27728;&#35211; &#27915;",
    dob: %{year: 1895, month: 7, day: 7},
    dod: %{year: 1964, month: 7, day: 1},
    birth_place: "Tokyo, Japan",
    death_place: "Tokyo, Japan"
  },
  %Person{
    id: "51ef93db-0b25-44e2-889d-b92768a49470",
    given_name: "Kei",
    family_name: "Beppu",
    gender: "M",
    showcase: false,
    original_name: "&#21029;&#24220;&#21843;"
  },
  %Person{
    id: "89b2d627-c97d-45d4-9a49-2432c39b7fb4",
    given_name: "Kyosuke",
    family_name: "Kami",
    gender: "M",
    showcase: false,
    original_name: "&#32025; &#24685;&#36628;",
    dob: %{year: 1901, month: 9, day: 3},
    dod: %{year: 1981, month: 3, day: 24},
    birth_place: "Otemachi, Hiroshima, Japan"
  },
  %Person{
    id: "7782090a-df05-4bf5-8791-f8efac8951f4",
    given_name: "Shuichi",
    family_name: "Ihara",
    gender: "M",
    showcase: false,
    original_name: "&#24245;&#21407; &#21608;&#19968;"
  },
  %Person{
    id: "8dddd2f4-0d44-40b8-ab2c-b927053f99bd",
    given_name: "Keiko",
    family_name: "Muramatsu",
    gender: "F",
    showcase: false,
    original_name: "&#26449;&#26494;&#24693;&#23376;"
  },
  %Person{
    id: "2971159a-b9d5-4858-be61-23b3e5d754fb",
    given_name: "Hajime",
    family_name: "Izu",
    gender: "M",
    showcase: false,
    original_name: "&#20234;&#35910; &#32903;",
    birth_name: "Hajime Watanabe (&#28193;&#37002; &#32903;)",
    dob: %{year: 1917, month: 7, day: 6},
    dod: %{year: 2005},
    birth_place: "Tokyo, Japan"
  },
  %Person{
    id: "a78fc680-c144-4f9a-8e27-fc69b70a463f",
    given_name: "Yoshio",
    family_name: "Nishikawa",
    gender: "M",
    showcase: false,
    original_name: "&#35199;&#24029;&#21892;&#30007;"
  },
  %Person{
    id: "6c891253-4c26-44fb-a952-fb1866d1819f",
    given_name: "Toshio",
    family_name: "Yasumi",
    gender: "M",
    showcase: false,
    original_name: "&#20843;&#20303; &#21033;&#38596;",
    dob: %{year: 1903, month: 4, day: 6},
    dod: %{year: 1991, month: 5, day: 22},
    birth_place: "Osaka, Japan"
  },
  %Person{
    id: "9da86934-7584-466a-84be-853819168103",
    given_name: "Ryuzo",
    family_name: "Kikushima",
    gender: "M",
    showcase: false,
    original_name: "&#33738;&#23798; &#38534;&#19977;",
    dob: %{year: 1914, month: 1, day: 28},
    dod: %{year: 1989, month: 3, day: 18},
    birth_place: "Kofu, Yamanashi, Japan"
  },
  %Person{
    id: "a37d0291-2e69-40af-86f0-133859aaf1ff",
    given_name: "Kisaku",
    family_name: "Ito",
    gender: "M",
    showcase: false,
    original_name: "&#20234;&#34276; &#29113;&#26388;",
    dob: %{year: 1899, month: 8, day: 1},
    dod: %{year: 1967, month: 3, day: 31},
    birth_place: "Misaki, Kanda, Tokyo, Japan"
  },
  %Person{
    id: "301600d5-0f05-49a5-a23b-3f5751da8ac0",
    given_name: "Hiroyuki",
    family_name: "Wakita",
    gender: "M",
    showcase: false,
    original_name: "&#33031;&#30000;&#21338;&#34892;"
  },
  %Person{
    id: "7a593862-ec98-49bb-bd73-b35094f16971",
    given_name: "Sei",
    family_name: "Ikeno",
    gender: "M",
    showcase: false,
    original_name: "&#27744;&#37326; &#25104;",
    dob: %{year: 1931, month: 2, day: 24},
    dod: %{year: 2004, month: 8, day: 13},
    birth_place: "Sapporo, Hokkaido, Japan",
    death_place: "Tokyo, Japan"
  },
  %Person{
    id: "e14a8f59-a0e9-4286-be13-24559916e2c4",
    given_name: "Kyoe",
    family_name: "Hamagami",
    gender: "M",
    showcase: false,
    original_name: "&#27996;&#19978;&#20853;&#34907;"
  },
  %Person{
    id: "7f06db03-42ca-4a84-bb01-a856eb036026",
    given_name: "Yoyo",
    family_name: "Miyata",
    gender: "M",
    showcase: false,
    original_name: "&#23470;&#30000; &#27915;&#23481;",
    birth_name: "Nobuo Iwashita (&#23721;&#19979; &#20449;&#22827;)",
    dob: %{year: 1915, month: 2, day: 16},
    dod: %{year: 1983, month: 7, day: 11},
    birth_place: "Kumamoto, Japan",
    aliases: ["Hitsujiyo Miyata (&#23470;&#30000; &#32650;&#23481;)"]
  },
  %Person{
    id: "07259617-c6ef-42ad-afac-b37d29f83e4e",
    given_name: "Rokuro",
    family_name: "Nishigaki",
    gender: "M",
    showcase: false,
    original_name: "&#35199;&#22435;&#20845;&#37070;"
  },
  %Person{
    id: "88bd531f-1ba5-40c9-9e81-4bf05ee61fce",
    given_name: "Hiromitsu",
    family_name: "Mori",
    gender: "M",
    showcase: false,
    original_name: "&#26862;&#24344;&#20805;"
  },
  %Person{
    id: "293342a6-c449-4ec7-9103-b3091a184cd2",
    given_name: "Kan",
    family_name: "Ishii",
    gender: "M",
    showcase: false,
    original_name: "&#30707;&#20117; &#27475;",
    dob: %{year: 1921, month: 3, day: 30},
    dod: %{year: 2009, month: 11, day: 24},
    birth_place: "Shitaya, Tokyo, Japan"
  },
  %Person{
    id: "1e17ee46-4e58-4e9a-bf1b-5487910aae4e",
    given_name: "Ross",
    family_name: "Bennett",
    gender: "M",
    showcase: false,
    japanese_name: "&#12525;&#12473;&#12539;&#12505;&#12493;&#12483;&#12488;"
  },
  %Person{
    id: "155ce21a-83a4-4059-bf88-08cf6d988842",
    given_name: "Fumio",
    family_name: "Sakashita",
    gender: "M",
    showcase: false,
    original_name: "&#38263;&#35895;&#24029; &#24344;"
  },
  %Person{
    id: "f0248816-9020-47ff-a5f2-b77c0e43002c",
    given_name: "Ko",
    family_name: "Nishimura",
    gender: "M",
    showcase: false,
    original_name: "&#35199;&#26449; &#26179;",
    dob: %{year: 1923, month: 1, day: 25},
    dod: %{year: 1997, month: 4, day: 15},
    birth_place: "Sapporo, Hokkaido, Japan",
    death_place: "Kokubunji, Tokyo, Japan"
  },
  %Person{
    id: "e5f1bba1-e4e2-452b-bb62-1747d34ca1e1",
    given_name: "Eishu",
    family_name: "Kin",
    gender: "M",
    showcase: false,
    original_name: "&#37329;&#26628;&#29664;"
  },
  %Person{
    id: "cd54d1db-167c-4361-98c4-6ebf75294ad0",
    given_name: "Yoshitami",
    family_name: "Kuroiwa",
    gender: "M",
    showcase: false,
    original_name: "&#40658;&#23721; &#32681;&#27665;"
  },
  %Person{
    id: "9d1ccb86-2857-4a3a-b0e3-f30030053941",
    given_name: "Takao",
    family_name: "Saito",
    gender: "M",
    showcase: false,
    original_name: "&#25998;&#34276; &#23389;&#38596;",
    dob: %{year: 1929, month: 3, day: 5},
    dod: %{year: 2014, month: 12, day: 6}
  },
  %Person{
    id: "439b033b-b72a-4ed0-b2fd-c44468378bc0",
    given_name: "Hiroko",
    family_name: "Sakurai",
    gender: "F",
    showcase: false,
    original_name: "&#26716;&#20117; &#28009;&#23376;",
    dob: %{year: 1946, month: 3, day: 4},
    birth_place: "Meguro, Tokyo, Japan"
  },
  %Person{
    id: "06d3db81-7ec1-4f1c-9df6-e210dba769b2",
    given_name: "Shunji",
    family_name: "Kasuga",
    gender: "M",
    showcase: false,
    original_name: "&#26149;&#26085; &#20426;&#20108;",
    dob: %{year: 1921, month: 6, day: 14},
    dod: %{unknown: 1},
    birth_place: "Niigata, Japan"
  },
  %Person{
    id: "f6e9be35-e3c6-41c6-b7d1-076cede500a2",
    given_name: "Hiroshi",
    family_name: "Ueda",
    gender: "M",
    showcase: false,
    original_name: "&#26893;&#30000; &#23515;"
  },
  %Person{
    id: "e77691f8-05d7-4ae8-a582-c51c41de9f0c",
    given_name: "Osamu",
    family_name: "Dazai",
    gender: "M",
    showcase: false,
    original_name: "&#22826;&#23472; &#27835;",
    birth_name: "Shuji Tsushima (&#27941;&#23798; &#20462;&#27835;)",
    dob: %{year: 1909, month: 6, day: 19},
    dod: %{year: 1948, month: 6, day: 13},
    birth_place: "Kanagi, Kitatsugaru, Aomori, Japan",
    death_place: "Kitatami, Tokyo, Japan"
  },
  %Person{
    id: "5a7a9af3-554a-451b-8835-78595116a9ff",
    given_name: "Hiroshi",
    family_name: "Nezu",
    gender: "M",
    showcase: false,
    original_name: "&#26681;&#27941; &#21338;"
  }
]

ids = Enum.map(people, fn p -> p.id end)

from(person in Person, where: person.id in ^ids) |> Repo.delete_all

Enum.each(people, fn p -> Repo.insert! p end)
