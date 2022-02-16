require "rails_helper"

RSpec.describe "authenticated requests" do
  def username
    ENV.fetch("BASIC_AUTH_USER")
  end

  def password
    ENV.fetch("BASIC_AUTH_PASSWORD")
  end

  def auth_headers(username, password)
    {headers: {"HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)}}
  end

  def authorized_get(username, password, path)
    get path, auth_headers(username, password)
  end

  def authorized_post(username, password, path, params)
    post path, auth_headers(username, password).merge(params: params)
  end

  def authorized_patch(username, password, path, params)
    patch path, auth_headers(username, password).merge(params: params)
  end

  def authorized_delete(username, password, path)
    delete path, auth_headers(username, password)
  end

  before do
    5.times { |i| create(:employee, name: "name-#{i + 1}", department: "development") }
  end

  context "invalid credentials" do
    it "denies access to the edit form of an epmloyee" do
      authorized_get username, "does not exists", edit_employee_path(random_employee)

      expect(response.status).to eq 401
    end

    it "denies access to the show an epmloyee" do
      authorized_get username, "does not exists", employee_path(random_employee)

      expect(response.status).to eq 401
    end

    it "denies access to index" do
      authorized_get username, "does not exists", employees_path

      expect(response.status).to eq 401
    end

    it "denies access to create" do
      employee_attrs = attributes_for(:employee)

      authorized_post username, "does not exists", employees_path, {employee: employee_attrs}

      expect(response.status).to eq 401
    end

    it "denies access to update" do
      employee_attrs = attributes_for(:employee)

      authorized_patch username, "does not exists", employee_path(random_employee), {employee: employee_attrs}

      expect(response.status).to eq 401
    end
  end

  context "valid credentials" do
    it "allows access to the edit form of an epmloyee" do
      authorized_get username, password, edit_employee_path(random_employee)

      expect(response.status).to eq 200
    end

    it "allows access to the show an epmloyee" do
      authorized_get username, password, employee_path(random_employee)

      expect(response.status).to eq 200
    end

    it "allows access to index" do
      authorized_get username, password, employees_path

      expect(response.status).to eq 200
    end

    it "allows access to create" do
      employee_attrs = attributes_for(:employee)

      authorized_post username, password, employees_path, {employee: employee_attrs}

      expect(response.status).to eq 302
    end

    it "allows access to update" do
      employee_attrs = attributes_for(:employee)

      authorized_patch username, password, employee_path(random_employee), {employee: employee_attrs}

      expect(response.status).to eq 302
    end
  end

  def random_employee
    Employee.all.sample
  end
end
