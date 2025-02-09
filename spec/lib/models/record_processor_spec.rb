# frozen_string_literal: true

RSpec.describe RecordProcessor do
  let(:processor) { described_class.new(file_path: '../../../data/records.xml') }

  describe '#initialize' do
    context 'when RecordProcessor is initialized' do
      it 'sets file_path' do
        expect(processor.file_path).to be_a String
        expect(processor.file_path).to eq('../../../data/records.xml') # store this in a constant
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
    let(:nokogiri) { subject::Nokogiri.new }
    context 'when the process method is called' do
      it 'returns a hash' do
        expect(processor.process).to be_a Hash
      end

      it 'returns a hash with valid_records' do
        expect(processor.process[:valid_records]).to be_a Set
      end

      it 'returns a hash with invalid_records' do
        expect(processor.process[:invalid_records]).to be_a Set
      end
    end
  end
end
