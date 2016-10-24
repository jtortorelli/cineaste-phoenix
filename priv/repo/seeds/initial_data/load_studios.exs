alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Studio

studios = [
  %Studio{
    id: "b52fcdd6-691b-4a16-a670-e6ad6f176521",
    name: "Toho"
  },
  %Studio{
    id: "a7136259-307b-4315-9247-4bd6ee60ae61",
    name: "Mifune Productions"
  }
]

ids = Enum.map(studios, fn s -> s.id end)

from(studio in Studio, where: studio.id in ^ids) |> Repo.delete_all

Enum.each(studios, fn x -> Repo.insert! x end)
