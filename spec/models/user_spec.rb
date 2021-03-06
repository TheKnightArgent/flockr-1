require 'spec_helper'


describe User do
  context 'without an email address' do
    it 'fails validation' do
      expect(User.new).to have(1).error_on(:email)
    end
  end

  context 'with a duplicate email address' do
    it 'fails validation' do
      User.create!(username: 'test', email: 'test@test.com')
      expect(User.new(email: 'test@test.com')).to have(1).error_on(:email)
    end
  end

  context 'without a username' do
    it 'fails validation' do
      expect(User.new).to have(1).error_on(:username)
    end
  end

  context 'with a duplicate username' do
    it 'fails validation' do
      User.create!(username: 'test', email: 'test@test.com')
      expect(User.new(username: 'test')).to have(1).error_on(:username)
    end
  end

  it 'can have many photos' do
    user = User.new(email: 'test@test.com', username: 'test')
    2.times { user.photos << Photo.new }
    expect(user).to be_valid
    user.save!
  end

  describe '#destroy' do
    it 'destroys associated photos' do
      photo = Photo.new
      user = User.create!(email: 'test@test.com', username: 'test', photos: [photo])

      expect { user.destroy }.to change { Photo.count }.by -1
    end
  end
end
