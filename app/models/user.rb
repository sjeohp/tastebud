require 'bcrypt'
 
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include BCrypt

  attr_accessor :password, :password_confirmation
  
  field :email,                     :type => String
  field :password_hash,             :type => String

  
  validates_presence_of :email, :message => "You must enter an email."
  validates_uniqueness_of :email, :message => "That email already in use."
  # validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :message => "Please Enter a Valid Email Address."
  validates_length_of :password, :minimum => 6, :message => "Your password must have at least 6 characters."
  validates_confirmation_of :password, :message => "Password confirmation didn't match."
  
  before_save :encrypt_password
  
  def self.find_by_email(email)
    u = User.where(email: email).first
  end
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)
    return nil if user.nil?
    Password.new(user.password_hash) == password ? user : nil
  end

  protected
  
  def encrypt_password
    self.password_hash = Password.create(@password)
  end
end