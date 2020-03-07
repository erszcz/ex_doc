defmodule ExDoc.Markdown do
  @moduledoc """
  Adapter behaviour and conveniences for converting Markdown to HTML.

  ExDoc is compatible with any markdown processor that implements the
  functions defined in this module. The markdown processor can be changed
  via the `:markdown_processor` option in your `mix.exs`.

  ExDoc supports the following Markdown parsers out of the box:

    * [Earmark](http://github.com/pragdave/earmark)

  ExDoc uses Earmark by default.
  """

  @doc """
  Converts markdown into HTML.
  """
  @callback to_html(String.t(), Keyword.t()) :: String.t()

  @markdown_processors [
    ExDoc.Markdown.Earmark
  ]

  @markdown_processor_key :markdown_processor

  @doc """
  Converts the given markdown document to HTML.
  """
  def to_html(text, opts \\ []) when is_binary(text) do
    get_markdown_processor().to_html(text, opts)
  end

  @doc """
  Gets the current markdown processor set globally.
  """
  def get_markdown_processor do
    case Application.fetch_env(:ex_doc, @markdown_processor_key) do
      {:ok, processor} ->
        processor

      :error ->
        processor = find_markdown_processor() || raise_no_markdown_processor()
        put_markdown_processor(processor)
        processor
    end
  end

  @doc """
  Changes the markdown processor globally.
  """
  def put_markdown_processor(processor) do
    Application.put_env(:ex_doc, @markdown_processor_key, processor)
  end

  defp find_markdown_processor do
    Enum.find(@markdown_processors, fn module ->
      Code.ensure_loaded?(module) && module.available?
    end)
  end

  defp raise_no_markdown_processor do
    raise """
    Could not find a markdown processor to be used by ex_doc.
    You can either:

    * Add {:earmark, ">= 0.0.0"} to your mix.exs deps
      to use an Elixir-based markdown processor
    """
  end
end
