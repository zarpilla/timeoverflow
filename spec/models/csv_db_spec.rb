require 'spec_helper'

describe CsvDb do
  describe '.convert_save' do
    let(:organization) { Fabricate(:organization) }
    let(:user) do
      User.new(
        username: 'paco perez fernandez',
        date_of_birth: '1989-03-16',
        email: 'paco@example.com',
        phone: '666677898',
        alt_phone: '666767876',
        gender: 'female'
      )
    end

    # member_id, entry_date, username, gender, date_of_birth, phone, alt_phone, email
    let(:csv_data) { StringIO.new('1,2018-01-30,paco,perez,fernandez,2,1989-03-16,666677898,666767876,paco@example.com') }

    before do
      allow(Organization)
        .to receive(:find).with(organization.id).and_return(organization)

      allow(User).to receive(:new).with(
        username: 'paco perez fernandez',
        date_of_birth: '1989-03-16',
        email: 'paco@example.com',
        phone: '666677898',
        alt_phone: '666767876',
        gender: 'female'
      ).and_return(user)
    end

    it 'creates a user out of a CSV row' do
      expect(User).to receive(:new).with(
        username: 'paco perez fernandez',
        date_of_birth: '1989-03-16',
        email: 'paco@example.com',
        phone: '666677898',
        alt_phone: '666767876',
        gender: 'female'
      ).and_return(user)

      described_class.convert_save(organization.id, csv_data)
    end

    it 'persists the user' do
      expect(user).to receive(:save)
      described_class.convert_save(organization.id, csv_data)
    end
  end
end
