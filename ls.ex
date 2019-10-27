defmodule LS do
    def main do
        currentDirStructure |> printDirStucture

        getDirStructure("readme") |> printDirStucture

        folderStructure(nil)
    end

    def currentDirStructure do
        getDirStructure(nil)
    end

    def getDirStructure(directory) do
        case directory do
            nil -> System.cmd("ls", [File.cwd!])
                |> lsTupleToDirList
            _ -> System.cmd("ls", [File.cwd! <> "\/" <> directory])
                |> lsTupleToDirList
        end
    end

    def printDirStucture(list) do
        if list !== nil do
            Enum.each(list, fn element -> IO.puts element end)
        end
    end

    def lsTupleToDirList(lsResponse) do
        Tuple.to_list(lsResponse)
            |> List.first()
            |> String.split("\n")
            |> Enum.filter(
                fn element ->
                    is_binary(element) and String.length(element) > 0
                end
            )
            |> Enum.filter(fn element -> not String.contains?(element, "\/") end)
    end

    def folderStructure(dir) do
        case dir do
            nil -> %{
                File.cwd! => currentDirStructure
                    |> Enum.map(fn element -> folderStructure(element) end)
            }
            _ -> %{
                dir |> String.split("\/") |> List.last()
                => getDirStructure(dir)
                    |> Enum.map(fn element -> folderStructure(dir <> "\/" <> element) end)
            }
        end
    end
end