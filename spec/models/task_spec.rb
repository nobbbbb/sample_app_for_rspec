require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      expect(build(:task)).to be_valid
    end

    it 'is invalid without title' do
      task_without_title = build(:task, title: nil)
      task_without_title.valid?
      expect(task_without_title.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without status' do
      task_without_status = build(:task, status: nil)
      task_without_status.valid?
      expect(task_without_status.errors[:status]).to include("can't be blank")
    end

    it 'is invalid with a duplicate title' do
      create(:task, title: 'title')
      task_with_same_title = build(:task, title: 'title')
      task_with_same_title.valid?
      expect(task_with_same_title.errors[:title]).to include("has already been taken")
    end

    it 'is valid with another title' do
      create(:task, title: 'title1')
      task_with_another_title = build(:task, title: 'title2')
      expect(task_with_another_title).to be_valid
    end
  end
end
