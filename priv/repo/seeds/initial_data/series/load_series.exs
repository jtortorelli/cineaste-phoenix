alias Ecto
import Ecto.Query
alias Cineaste.Repo
alias Cineaste.Series

series = [
  %Series{
    id: "abf663c4-4467-4a76-a25f-735b00fbc120",
    name: "Godzilla"
  },
  %Series{
    id: "7719d635-5ead-451c-bd0a-f901523814aa",
    name: "Frankenstein"
  }
]

ids = Enum.map(series, fn s -> s.id end)
from(series in Series, where: series.id in ^ids) |> Repo.delete_all
Enum.each(series, fn x -> Repo.insert! x end)