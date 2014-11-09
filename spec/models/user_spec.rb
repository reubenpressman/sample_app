require 'spec_helper'

describe User do
	
	before { @user = User.new(name: "Example User", email: "user@example.com") }

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }

	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "name should not be too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "email should not be too long" do
		before { @user.email = "a" * 256 } 
		it { should_not be_valid }
	end

	describe "email validation should not accept invalid addresses" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "email validation should accept valid addresses" do
		it "should be valid" do
			addresses = %w[user@example.com USER@foo.com A_USER@foo.bar.org first.last@foo.jp alicebob@baz.cn]
			addresses.each do |address|
				@user.email = address
				@user.should be_valid
			end
		end
	end

	describe "email addresses should be unqiue" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

end