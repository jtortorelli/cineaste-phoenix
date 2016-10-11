alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Film
alias Cineaste.Person
alias Cineaste.StaffPersonRole

dogora = Repo.one from f in Film, where: f.title == "Dogora, the Space Monster"

by_name = fn(given_name, family_name) ->
  from p in Person, where: p.given_name == ^given_name and p.family_name == ^family_name
end

ishiro_honda = Repo.one(by_name.("Ishiro", "Honda"))
eiji_tsuburaya = Repo.one(by_name.("Eiji", "Tsuburaya"))
tomoyuki_tanaka = Repo.one(by_name.("Tomoyuki", "Tanaka"))
yasuyoshi_tajitsu = Repo.one(by_name.("Yasuyoshi", "Tajitsu"))
jojiro_okami = Repo.one(by_name.("Jojiro", "Okami"))
shinichi_sekizawa = Repo.one(by_name.("Shinichi", "Sekizawa"))
hajime_koizumi = Repo.one(by_name.("Hajime", "Koizumi"))
takeo_kita = Repo.one(by_name.("Takeo", "Kita"))
fumio_yanoguchi = Repo.one(by_name.("Fumio", "Yanoguchi"))
shoshichi_kojima = Repo.one(by_name.("Shoshichi", "Kojima"))
akira_ifukube = Repo.one(by_name.("Akira", "Ifukube"))
ryohei_fujii = Repo.one(by_name.("Ryohei", "Fujii"))
sadamasa_arikawa = Repo.one(by_name.("Sadamasa", "Arikawa"))
teruyoshi_nakano = Repo.one(by_name.("Teruyoshi", "Nakano"))

roles = [
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: ishiro_honda.id,
    role: "Director",
    order: -2
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: eiji_tsuburaya.id,
    role: "Special Effects Director",
    order: -1
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: tomoyuki_tanaka.id,
    role: "Producer",
    order: 1
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: yasuyoshi_tajitsu.id,
    role: "Producer",
    order: 2
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: jojiro_okami.id,
    role: "Original Story",
    order: 3
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: shinichi_sekizawa.id,
    role: "Screenplay",
    order: 4
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: hajime_koizumi.id,
    role: "Cinematography",
    order: 5
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: takeo_kita.id,
    role: "Art Director",
    order: 6
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: fumio_yanoguchi.id,
    role: "Sound Recording",
    order: 7
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: shoshichi_kojima.id,
    role: "Lighting",
    order: 8
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: akira_ifukube.id,
    role: "Music",
    order: 9
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: ryohei_fujii.id,
    role: "Editor",
    order: 12
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: sadamasa_arikawa.id,
    role: "Special Effects Cinematography",
    order: 16
  },
  %StaffPersonRole{
    film_id: dogora.id,
    person_id: teruyoshi_nakano.id,
    role: "Special Effects Assistant Director",
    order: 23
  }
]

from(role in StaffPersonRole, where: role.film_id == ^dogora.id) |> Repo.delete_all

Enum.each(roles, fn x -> Repo.insert! x end)
