defmodule Exbugs.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:thumb, :small]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 150x150^ -gravity center -extent 150x150 -format png"}
  end

  def transform(:small, _) do
    {:convert, "-strip -thumbnail 44x44^ -gravity center -extent 44x44 -format png"}
  end

  def filename(version, _) do
    version
  end

  def __storage, do: Arc.Storage.Local

  def storage_dir(version, {file, scope}) do
    "priv/static/images/avatars/#{scope.id}"
  end

  def default_url(version, scope) do
    "/images/avatars/default_#{version}.png"
  end
end
