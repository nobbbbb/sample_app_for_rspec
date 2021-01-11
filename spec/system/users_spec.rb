require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        example 'ユーザーの新規作成が成功する' do
          visit sign_up_path
          fill_in 'Email', with: 'foobar@example.com'
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'SignUp'
          expect(page).to have_content 'successfully'
          expect(current_path).to eq login_path
        end
      end
      context 'メールアドレスが未入力' do
        example 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'SignUp'
          expect(page).to have_content "can't be blank"
          expect(current_path).to eq users_path
        end
      end
      context '登録済のメールアドレスを使用' do
        example 'ユーザーの新規作成が失敗する' do
          visit sign_up_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'SignUp'
          expect(page).to have_content 'has already been taken'
          expect(current_path).to eq users_path
        end
      end
    end
    describe 'マイページ' do
      context 'ログインしていない状態' do
        example 'マイページへのアクセスが失敗する' do
          visit sign_up_path
          fill_in 'Email', with: 'foobar@example.com'
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'SignUp'
          visit users_path(user)
          expect(page).to have_content 'Login required'
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    let!(:other_user) { create(:user)}
    before { login(user) }
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        example 'ユーザーの編集が成功する' do
          visit edit_user_path(user)
          fill_in 'Email', with: 'updated@example.com'
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'Update'
          expect(page).to have_content 'successfully'
          expect(current_path).to eq user_path(user)
        end
      end
      context 'メールアドレスが未入力' do
        example 'ユーザーの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: nil
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'Update'
          expect(page).to have_content "can't be blank"
          expect(current_path).to eq user_path(user)
        end
      end
      context '登録済のメールアドレスを使用' do
        example 'ユーザの編集が失敗する' do
          visit edit_user_path(user)
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'foobar'
          fill_in 'Password confirmation', with: 'foobar'
          click_button 'Update'
          expect(page).to have_content 'has already been taken'
          expect(current_path).to eq user_path(user)
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        example '編集ページへのアクセスが失敗する' do
          visit edit_user_path(other_user)
          expect(page).to have_content 'Forbidden access'
          expect(current_path).to eq user_path(user)
        end
      end
    end

    describe 'マイページ' do
      context 'タスクを作成' do
        example '新規作成したタスクが表示される' do
          visit new_task_path(user)
          fill_in 'Title', with: 'title'
          fill_in 'Content', with: 'content'
          select 'todo', from: task[status]
          click_button 'Create Task'
          expect(page).to have_content 'successfully'
          visit user_path(user)
          expect(page).to have_content 'title'
          expect(page).to have_content 'todo'
        end
      end
    end
  end
end
