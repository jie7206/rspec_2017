require 'rails_helper'

RSpec.describe User, type: :model do
  it "拥有有效的预构件 has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end
  it "属性必须有效 is valid with a first name, last name, email, and password" do
    user = User.new(
      first_name: "Aaron",
      last_name:  "Sumner",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    expect(user).to be_valid
  end
  it "必须有名字 is invalid without a first name" do
    user = FactoryGirl.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end
  it "必须有姓氏 is invalid without a last name" do
    user = FactoryGirl.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end
  it "必须有邮箱 is invalid without an email address" do
    user = FactoryGirl.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  it "邮箱不能重复 is invalid with a duplicate email address" do
    FactoryGirl.create(:user, email: "aaron@example.com")
    user = FactoryGirl.build(:user, email: "aaron@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
  it "能回传完整的姓名 returns a user's full name as a string" do
    user = FactoryGirl.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
  end
end
