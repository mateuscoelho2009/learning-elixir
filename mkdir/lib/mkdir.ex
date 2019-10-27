defmodule Mkdir do
  def main(
    file \\ "dir.json",
    basePath \\ ".."
  ) do
    {:ok, body} = File.read(file)

    {:ok, map} = Poison.decode(body)

    createDirectoryRecursivelyFromMap(map, basePath)
  end

  def makeDirectory(dir) do
    case dir do
      nil -> IO.puts "No directory specified"
      _ -> System.cmd("mkdir", [dir])
    end
  end

  def createDirectoryRecursivelyFromMap(map, basePath) do
    keys = Map.keys(map)

    keys
    # Creates directories
    |> Enum.each(fn key -> makeDirectory(basePath <> "\/" <> key) end)
    
    keys
    # Get child directories
    |> Enum.each(fn key ->
        value = Map.get(map, key)

        IO.puts basePath <> "\/" <> key

        # Create child directories
        createDirectoryRecursivelyFromMap(value, basePath <> "\/" <> key)
      end)
  end
end
