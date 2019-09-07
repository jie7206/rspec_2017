require 'rails_helper'

RSpec.describe Note, type: :model do

  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project, owner: user) }

  it "验证模型有效 is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note.",
      user: user,
      project: project,
    )
    expect(note).to be_valid
  end

  it "没有文字则无效 is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "搜索讯息关键字 search message for a term" do

    let!(:note1) {
      FactoryGirl.create(:note,
        project: project,
        user: user,
        message: "This is the first note." ) }

    let!(:note2) {
      FactoryGirl.create(:note,
        project: project,
        user: user,
        message: "This is the second note." ) }

    let!(:note3) {
      FactoryGirl.create(:note,
        project: project,
        user: user,
        message: "First, preheat the oven." ) }

    context "当找到相关讯息 when a match is found" do
      it "返回讯息集合 returns notes that match the search term" do
        expect(Note.search("first")).to include(note1, note3)
      end
    end

    context "当没有找到讯息 when no match is found" do
      it "返回空集合 returns an empty collection" do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end

  end

end
