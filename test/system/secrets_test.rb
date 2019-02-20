require "application_system_test_case"

class SecretsTest < ApplicationSystemTestCase
  setup do
    @secret = secrets(:one)
  end

  test "visiting the index" do
    visit secrets_url
    assert_selector "h1", text: "Secrets"
  end

  test "creating a Secret" do
    visit secrets_url
    click_on "New Secret"

    fill_in "Encrypted body", with: @secret.encrypted_body
    fill_in "Encrypted body iv", with: @secret.encrypted_body_iv
    fill_in "Expiration", with: @secret.expiration
    fill_in "Password", with: @secret.password
    fill_in "Title", with: @secret.title
    click_on "Create Secret"

    assert_text "Secret was successfully created"
    click_on "Back"
  end

  test "updating a Secret" do
    visit secrets_url
    click_on "Edit", match: :first

    fill_in "Encrypted body", with: @secret.encrypted_body
    fill_in "Encrypted body iv", with: @secret.encrypted_body_iv
    fill_in "Expiration", with: @secret.expiration
    fill_in "Password", with: @secret.password
    fill_in "Title", with: @secret.title
    click_on "Update Secret"

    assert_text "Secret was successfully updated"
    click_on "Back"
  end

  test "destroying a Secret" do
    visit secrets_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Secret was successfully destroyed"
  end
end
