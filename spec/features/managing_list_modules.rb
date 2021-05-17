require 'rails_helper'

describe 'Managing ListModules' do

  specify 'I can add a list module' do
    @user = create(:user, id: 123, username: 'fill in', password: 'fill in', admin: true)
    login_as(@user)
    visit '/admin'
    click_on('Manage Modules')


    visit '/admin/modules/create'

    fill_in 'inputName', with: 'Test Module'
    fill_in 'inputCode', with: 'COM123'
    fill_in 'inputDescription', with: 'Sample Description'
    select 'AUTUMN', from: 'module_create_form_semester'
    select '2022/2023', from: 'module_create_form_years'
    select '4', from: 'module_create_form_level'
    save_and_open_page('/home/seth/Documents/screenshot')
    find('#submit_choice').click
    visit '/admin/modules'

    within(:css, '.mb-0') { expect(page).to have_content ''}
  end
end
