require 'rails_helper'

RSpec.describe Task, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # Case: 1
  context "title を指定しているとき" do
    it "タスクが作成される" do
      # binding.pry
      task = build(:task)
      expect(task).to be_valid
    end
  end
  # Case: 2
  context "title を指定していないとき" do
    it "タスクの作成に失敗する" do
      # params = attributes_for(:task)
      task = build(:task, title: nil)
      expect(task).to be_invalid
      expect(task.errors.details[:title][0][:error]).to eq :blank
      # binding.pry
    end
  end


end
