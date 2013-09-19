require 'spec_helper'


describe User do
  subject do
    User.new(username: 'test', email: 'test@test.com', password: 'password',
             password_confirmation: 'password')
  end

  it { should respond_to :username }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should be_valid }

  describe 'email' do
    context 'when not provided' do
      it 'fails validation' do
        expect(User.new).to have(1).error_on(:email)
      end
    end

    context 'with a duplicate' do
      it 'fails validation' do
        subject.save!
        expect(User.new(email: subject.email)).to have(1).error_on(:email)
      end
    end

    context 'when created as upcased' do
      it 'saves the address as lowercase' do
        subject.email = 'TEST@Test.com'
        subject.save
        expect(subject.email).to eq 'test@test.com'
      end
    end
  end

  describe 'username' do
    context 'when not provided' do
      it 'fails validation' do
        expect(User.new).to have(1).error_on(:username)
      end
    end

    context 'when a duplicate' do
      it 'fails validation' do
        subject.save!
        expect(User.new(username: subject.username)).to have(1).error_on(:username)
      end
    end

    context 'when created as upcased' do
      it 'saves the username as lowercase' do
        subject.username = 'TeSt'
        subject.save
        expect(subject.username).to eq 'test'
      end
    end
  end

  describe 'password' do
    context 'when not provided' do
      before do
        subject.password = ' '
        subject.password_confirmation = ' '
      end

      it { should_not be_valid }
    end

    context 'when confirmation does not match' do
      before do
        subject.password_confirmation = 'mismatch'
      end

      it { should_not be_valid }
    end
  end

  describe 'photos' do
    it 'can have many photos' do
      2.times { subject.photos << Photo.new }
      expect(subject).to be_valid
      subject.save!
    end
  end

  describe '#destroy' do
    it 'destroys associated photos' do
      photo = Photo.new
      subject.photos << photo
      subject.save

      expect { subject.destroy }.to change { Photo.count }.by -1
    end
  end
end