# frozen_string_literal: true

RSpec.describe RecordProcessor do
  let(:processor) { described_class.new(file_path: './data/records.xml') }

  describe '#initialize' do
    context 'when RecordProcessor is created' do
      it 'sets file_path' do
        expect(processor.file_path).to be_a String
        expect(processor.file_path).to eq('./data/records.xml') # store this in a constant
        expect(processor.file_path).to_not eq('')
      end

      it 'sets valid_records' do
        expect(processor.valid_records).to be_a Set
        expect(processor.valid_records).to be_empty
      end

      it 'sets invalid_records' do
        expect(processor.invalid_records).to be_a Set
        expect(processor.invalid_records).to be_empty
      end
    end
  end

  describe 'attribute readers and writers' do
    it 'allows reading but not writing of file path' do
      expect(processor).to respond_to(:file_path)
      expect(processor).to_not respond_to(:file_path=)
    end

    it 'allows reading but not writing of valid_records' do
      expect(processor).to respond_to(:valid_records)
      expect(processor).to_not respond_to(:valid_records=)
    end

    it 'allows reading but not writing of invalid_records' do
      expect(processor).to respond_to(:invalid_records)
      expect(processor).to_not respond_to(:invalid_records=)
    end
  end

  describe '#process' do
    context 'when the process method is called' do
      it 'returns a hash' do
        expect(processor.process).to be_a Hash
      end

      it 'returns a hash with valid_records' do
        expect(processor.process[:valid]).to be_a Set
      end

      it 'returns a hash with invalid_records' do
        expect(processor.process[:invalid]).to be_a Set
      end
    end
  end

  describe '#valid_record?' do
    let(:person) {
    {
      first_names: 'Marty',
      last_name: 'McFly',
      full_name: 'Marty McFly',
      date_of_birth: Date.new(1968, 06, 03),
      address: { line1: '123 test street testtown', postcode: 'DS12 3AS' },
      years_at_address: 7,
      passport_number: 'AB675863',
      national_insurance_number: nil
    }
  }
  let(:record) { Record.new(**person) }
    context 'when the valid_record? method is called' do
      it 'returns true for valid records' do
        expect(processor.send(:valid_name_length?, record: record, attribute: :first_names)).to be true
        expect(processor.send(:valid_name_length?, record: record, attribute: :last_name)).to be true
        expect(processor.send(:valid_name_characters?, record: record)).to be true
        expect(processor.send(:valid_age?, record: record)).to be true
        expect(processor.send(:valid_years_at_address?, record: record)).to be true
        expect(processor.send(:valid_identity_numbers?, record: record)).to be true
        expect(processor.send(:valid_address?, record: record)).to be true
      end

      it 'returns false for invalid records' do
        attributes = person.except(:passport_number, :national_insurance_number)
        expect(processor.send(:valid_identity_numbers?, record: Record.new(**attributes))).to be false
      end
    end
  end
end
