defmodule ExDoc.Language do
end

defmodule ExDoc.Language.Elixir do
end

defmodule ExDoc.Language.Erlang do

  @otp_apps for path <- Path.wildcard(:code.lib_dir() ++ '/*'), do:
    path
    |> String.split("/")
    |> List.last()
    |> String.split("-")
    |> List.first()
    |> String.to_atom()

  def otp_apps, do: @otp_apps

  def module_origin(module) do
    case :code.which(module) do
      :preloaded ->
        :erlang_otp
      :non_existing ->
        :no_tool
      _ ->
        case :application.get_application(module) do
          {:ok, app} when app in @otp_apps ->
            :erlang_otp
          _ ->
            :erlang
        end
    end
  end

  def to_ast(doc, _options),
   do: doc

end
