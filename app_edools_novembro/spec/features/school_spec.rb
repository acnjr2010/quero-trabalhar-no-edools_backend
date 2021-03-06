# encoding: utf-8
require 'rails_helper'
require 'spec_helper'
require 'capybara/rspec'
include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

Capybara.javascript_driver = :selenium

describe 'when access schools page', js: true do
  let(:user) { FactoryGirl.create(:user) }

  it 'create a new school' do
    visit '/users/sign_up'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    fill_in 'user_password_confirmation', with: user.password
    click_button 'Sign up'
    click_button 'Nova Escola'
    fill_in 'Nome da Escola', with: 'FooBar'
    fill_in 'Email da Escola', with: 'foobar@gmail.com'
    fill_in 'Pitch', with: 'FooBarFooBar FooBar'
    fill_in 'Subdominio', with: 'foo-bar.edools.com'
    page.attach_file('school_image', Rails.root + 'spec/fixture/rails.png')
    click_on 'Cadastrar'

    expect(page).to have_content('Escola cadastrada com sucesso.')
  end

  xit 'try to duplicate a record in the database' do
    new_school
    visit '/'
    click_on 'Nova Escola'
    fill_in 'Nome', with: 'New School'
    fill_in 'Email', with: 'foobar@gmail.com'
    fill_in 'Pitch', with: 'FooBarFooBarFooBar'
    fill_in 'Subdominio', with: 'foobar.edools.com'
    click_on 'Create School'

    expect(page).to have_content('3 erros no preenchimento ')
    expect(page).to have_content('O nome já está sendo utilizado')
    expect(page).to have_content('O email já está sendo utilizado')
    expect(page).to have_content('Este subdominio já foi escolhido')
  end

  it 'invalid subdomain' do
    visit '/'
    click_on 'Nova Escola'
    fill_in 'Nome', with: 'Another School'
    fill_in 'Email', with: 'foo-bar@gmail.com'
    fill_in 'Pitch', with: 'Foo-Bar-Foo-Bar-Foo-Bar'
    fill_in 'Subdominio', with: 'foo-bar.com.br'
    click_on 'Create School'

    expect(page).to have_content('1 erro no preenchimento')
    expect(page).to have_content('O campo subdominio está com um formato inválido')
  end

  it 'edit a school'  do
    visit '/'
    click_on 'FooBar'
    click_on 'Editar'
    fill_in 'Nome', with: 'Escola Teste'
    fill_in 'Email', with: 'foo-bar@gmail.com'
    click_on 'Update School'

    expect(page).to have_content('Escola atualizada com sucesso.')
  end

  xit 'destroy a school' do
    new_school
    visit '/'
    click_on 'New School'
    click_link 'Deletar'

    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content('Escola removida com sucesso.')
  end

  it 'test button back' do
    new_school
    visit '/'
    click_on 'New School'
    click_on 'Voltar'

    expect(page).to have_content('Controle de Escolas')
  end

  def new_school
    visit '/'
    click_on 'Nova Escola'
    fill_in 'Nome', with: 'New School'
    fill_in 'Email', with: 'foobar@gmail.com'
    fill_in 'Pitch', with: 'FooBarFooBarFooBar'
    fill_in 'Subdominio', with: 'foobar.edools.com'
    click_on 'Create School'
  end
end
