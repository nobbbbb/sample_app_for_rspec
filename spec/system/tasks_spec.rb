require 'rails_helper'

RSpec.describe "Tasks", type: :system do
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
    before { login(user) }

    describe 'タスクの新規作成' do
      context 'フォームの入力値が正常' do
        example 'タスクの新規作成が成功する' do
          visit new_task_path
          fill_in 'Title', with: 'test_title'
          fill_in 'Content', with: 'test_content'
          select 'todo', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create Task'
          expect(page).to have_content 'Title: test_title'
          expect(page).to have_content 'Content: test_content'
          expect(page).to have_content 'Status: todo'
          expect(page).to have_content 'Deadline: 2020/6/1 10:30'
          expect(current_path).to eq '/tasks/1'
        end
      end
      context 'タイトルが未入力' do
        example 'タスクの新規作成が失敗する' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: 'test_content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq tasks_path
        end
      end
      context '登録済のタイトルを入力' do
        example 'タスクの新規作成が失敗する' do
          visit new_task_path
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: 'test_content'
          click_button 'Create Task'
          expect(page).to have_content '1 error prohibited this task from being saved:'
          expect(page).to have_content 'Title has already been taken'
          expect(current_path).to eq tasks_path
        end
      end
    end
    describe 'タスク編集' do
      let!(:task) { create(:task, user: user) }
      let(:other_task) { create(:task, user: user) }
      before { visit edit_task_path(task) }

      context 'フォームの入力値が正常' do
        example 'タスクの編集が成功する' do
          fill_in 'Title', with: 'update_title'
          select 'done', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content 'Title: update_title'
          expect(page).to have_content 'Status: done'
          expect(page).to have_content 'Task was successfully updated.'
          expect(current_path).to eq task_path(task)
        end
      end
      context 'タイトルが未入力' do
        example 'タスクの編集が失敗する' do
          fill_in 'Title', with: nil
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq task_path(task)
        end
      end
      context '登録済のタイトルを入力' do
        example 'タスクの編集が失敗する' do
          fill_in 'Title', with: other_task.title
          select :todo, from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content '1 error prohibited this task from being saved'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'タスク削除' do
      let!(:task) { create(:task, user: user) }

      example 'タスクの削除が成功する' do
        visit tasks_path
        click_on 'Destroy'
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'successfully'
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end
end
