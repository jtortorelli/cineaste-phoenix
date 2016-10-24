alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Group

groups = [
  %Group{
    id: "5bbcef55-15b8-4fc1-a507-a115d57bfbbf",
    name: "The Peanuts",
    showcase: true,
    active_start: 1959,
    active_end: 1975,
    props: %{japanese_name: "&#12470;&#12539;&#12500;&#12540;&#12490;&#12483;&#12484;"}
  },
  %Group{
    id: "660408b0-763e-451b-a3de-51cad893c087",
    name: "The Bambi Pair",
    showcase: false,
    props: %{japanese_name: "&#12506;&#12450;&#12539;&#12496;&#12531;&#12499;"}
  }
]

ids = Enum.map(groups, fn g -> g.id end)
from(group in Group, where: group.id in ^ids) |> Repo.delete_all
Enum.each(groups, fn x -> Repo.insert! x end)