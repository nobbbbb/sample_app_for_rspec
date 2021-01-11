require 'rails_helper'

RSpec.describe "Tasks", js: true, type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    context 'タスクの新規作成' do
      example '新規作成ページへの移動が失敗する' do
        visit new_task_path
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end
    context 'タスクの編集' do
      example '編集ページへの移動が失敗する' do
        visit edit_task_path(task)
        expect(page).to have_content 'Login required'
        expect(current_path).to eq login_path
      end
    end
    context 'タスクの詳細' do
      example 'タスクの詳細情報が表示される' do
        visit task_path(task)
        expect(page).to have_content task.title
        expect(current_path).to eq task_path(task)
      end
    end
    context 'タスク一覧' do
      example '全てのユーザーのタスク情報が表示される' do
        task_list = create_list(:task, 3)
        visit tasks_path
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[2].title
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe 'ログイン後' do
    before do
      login(user)
    end
    context 'タスクの新規作成' do
      example 'タスクの新規作成が成功する' do
        visit new_task_path
        fill_in 'Title', with: 'title1'
        fill_in 'Content', with: 'content1'
        select 'todo', from: 'Status'
        click_button 'Create Task'
        expect(page).to have_content 'successfully'
        expect(current_path).to eq '/tasks/1'
        visit tasks_path
        expect(page).to have_content 'title1'
      end
    end
    context 'タスクの編集、削除' do
      let!(:task) { create(:task, user: user) }
      example 'タスクの編集が成功する' do
        visit edit_task_path(task)
        fill_in 'Title', with: 'update_title'
        fill_in 'Content', with: 'update_content'
        select 'done', from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content 'successfully'
        expect(current_path).to eq task_path(task)
        visit tasks_path
        expect(page).to have_content 'update_title'
      end
      example 'タスクの削除が成功する' do
        visit tasks_path
        click_on 'Destroy'
        expect(page).to have_content 'successfully'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end


end
