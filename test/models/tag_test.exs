defmodule Exbugs.TagTest do
  use Exbugs.ModelCase

  alias Exbugs.{Tag, Tagging, Ticket, Repo}

  import Exbugs.Factory

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "add tags" do
    ticket = create(:ticket)
    Tag.add_tags("ticket", ticket, "ruby, erlang")

    ruby_tag = Repo.get_by(Tag, name: "ruby")
    erlang_tag = Repo.get_by(Tag, name: "erlang")

    assert ruby_tag
    assert erlang_tag

    assert Repo.get_by(Tagging, %{tag_id: ruby_tag.id, type: "ticket", tagging_id: ticket.id})
    assert Repo.get_by(Tagging, %{tag_id: erlang_tag.id, type: "ticket", tagging_id: ticket.id})
  end

  test "taggable" do
    first = create(:ticket)
    second = create(:ticket)
    third = create(:ticket)

    Tag.add_tags("ticket", first, "first, second")
    Tag.add_tags("ticket", second, "second, third")
    Tag.add_tags("ticket", third, "four, five")

    taggable = Tag.taggable(Exbugs.Ticket, "second")

    assert 2 = taggable |> Repo.all |> Enum.count
    assert [] = Tag.taggable(Exbugs.Ticket, "six")
  end

  test "has tags" do
    ticket = create(:ticket)
    another_ticket = create(:ticket)

    Tag.add_tags("ticket", ticket, "tag, tag2, tag3")

    assert Tag.has_tags?(Exbugs.Ticket, ticket)
    refute Tag.has_tags?(Exbugs.Ticket, another_ticket)
  end

  test "tags for" do
    ticket = create(:ticket)
    another_ticket = create(:ticket)
    tags = "ruby, ruby on rails, rspec"

    Tag.add_tags("ticket", ticket, tags)

    assert ["ruby", "ruby on rails", "rspec"] = Tag.tags_for(Exbugs.Ticket, ticket)
    assert [] = Tag.tags_for(Exbugs.Ticket, another_ticket)
  end

  test "validate tags length" do
    valid_attrs = %{"title" => "title", "body" => "ticket body", "tags" => "ruby, erlang"}
    invalid_attrs = %{"title" => "title", "body" => "ticket body", "tags" => "r, e"}

    ticket = Ecto.build_assoc(create(:board), :tickets, user_id: create(:user).id)

    valid_changeset = Ticket.changeset(ticket, valid_attrs)
    invalid_changeset = Ticket.changeset(ticket, invalid_attrs)

    assert valid_changeset.valid?
    refute invalid_changeset.valid?
  end

  test "validate tags count" do
    valid_attrs = %{"title" => "title", "body" => "ticket body", "tags" => "ruby, erlang"}
    invalid_attrs = %{"title" => "title", "body" => "ticket body", "tags" => "ruby"}

    ticket = Ecto.build_assoc(create(:board), :tickets, user_id: create(:user).id)

    valid_changeset = Ticket.changeset(ticket, valid_attrs)
    invalid_changeset = Ticket.changeset(ticket, invalid_attrs)

    assert valid_changeset.valid?
    refute invalid_changeset.valid?
  end
end
