"./test/fixtures"
  |> File.ls!
  |> Enum.filter(fn f -> String.ends_with?(f, ".exs") end)
  |> Enum.map(fn f -> "./test/fixtures/#{f}" end)
  |> Enum.map(&Code.require_file/1)

ExUnit.start()
