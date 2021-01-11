module SignupMacros
  def sign_up(user)
    visit sign_up_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_button 'SignUp'
  end
end
