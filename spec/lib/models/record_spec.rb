# frozen_string_literal: true

require_relative '../../../lib/models/record'

RSpec.describe Record do
  let(:valid_attributes) do
    {
      first_names: 'John',
      last_name: 'Doe',
      date_of_birth: '1990-01-01',
      years_at_address: 5,
      address: { line1: '123 Test St', postcode: 'AB12 3CD' },
      passport_number: '123456789',
      national_insurance_number: 'AB123456C'
    }
  end

  describe '#initialize' do
    context 'with valid attributes' do
      subject(:record) { described_class.new(**valid_attributes) }

      it 'sets the first names' do
        expect(record.first_names).to eq('John')
      end

      it 'sets the last name' do
        expect(record.last_name).to eq('Doe')
      end

      it 'sets the date of birth' do
        expect(record.date_of_birth).to eq('1990-01-01')
      end

      it 'sets the years at address' do
        expect(record.years_at_address).to eq(5)
      end

      it 'sets the full name' do
        expect(record.full_name).to eq('John Doe')
      end

      it 'sets the address' do
        expect(record.address).to eq({ line1: '123 Test St', postcode: 'AB12 3CD' })
      end

      it 'sets the passport number' do
        expect(record.passport_number).to eq('123456789')
      end

      it 'sets the national insurance number' do
        expect(record.national_insurance_number).to eq('AB123456C')
      end
    end

    context 'with missing required attributes' do
      it 'raises an error when first_names is missing' do
        attributes = valid_attributes.except(:first_names)
        expect { described_class.new(**attributes) }.to raise_error(ArgumentError)
      end

      it 'raises an error when last_name is missing' do
        attributes = valid_attributes.except(:last_name)
        expect { described_class.new(**attributes) }.to raise_error(ArgumentError)
      end

      it 'raises an error when date_of_birth is missing' do
        attributes = valid_attributes.except(:date_of_birth)
        expect { described_class.new(**attributes) }.to raise_error(ArgumentError)
      end

      it 'raises an error when years_at_address is missing' do
        attributes = valid_attributes.except(:years_at_address)
        expect { described_class.new(**attributes) }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'attribute readers and writers' do
    subject(:record) { described_class.new(**valid_attributes) }

    it 'allows reading but not writing date_of_birth' do
      expect(record).to respond_to(:date_of_birth)
      expect(record).not_to respond_to(:date_of_birth=)
    end

    it 'allows reading but not writing passport_number' do
      expect(record).to respond_to(:passport_number)
      expect(record).not_to respond_to(:passport_number=)
    end

    it 'allows reading but not writing national_insurance_number' do
      expect(record).to respond_to(:national_insurance_number)
      expect(record).not_to respond_to(:national_insurance_number=)
    end

    it 'allows reading and writing first_names' do
      expect(record).to respond_to(:first_names)
      expect(record).to respond_to(:first_names=)
    end

    it 'allows reading and writing last_name' do
      expect(record).to respond_to(:last_name)
      expect(record).to respond_to(:last_name=)
    end
  end
end
