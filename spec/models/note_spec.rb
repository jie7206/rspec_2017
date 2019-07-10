require 'rails_helper'

RSpec.describe Note, type: :model do

  it "从预构件建立关联数据 generates associated data from a factory" do
    note = FactoryGirl.create(:note)
    puts "This note's project is #{note.project.inspect}"
    puts "This note's user is #{note.user.inspect}"
  end
  
  before do
    @user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    @project = @user.projects.create(
      name: "Test Project",
    )
  end

  it "验证模型有效 is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note.",
      user: @user,
      project: @project,
    )
    expect(note).to be_valid
  end

  it "没有文字则无效 is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "搜索讯息关键字 search message for a term" do

    before do
      @note1 = @project.notes.create(
        message: "This is the first note.",
        user: @user,
      )
      @note2 = @project.notes.create(
        message: "This is the second note.",
        user: @user,
      )
      @note3 = @project.notes.create(
        message: "First, preheat the oven.",
        user: @user,
      )
    end

    context "当找到相关讯息 when a match is found" do
      it "返回讯息集合 returns notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
      end
    end

    context "当没有找到讯息 when no match is found" do
      it "返回空集合 returns an empty collection" do
        expect(Note.search("message")).to be_empty
      end
    end

  end

end
