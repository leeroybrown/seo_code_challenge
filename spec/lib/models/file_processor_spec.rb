# frozen_string_literal: true

RSpec.describe FileProcessor do
  let(:processor) { FileProcessor.new(file_name: 'test', records: []) }
  describe '#initialize' do
    context 'when the object is created' do
      it 'sets file_name' do
        expect(processor.file_name).to eq('test')
        expect(processor.file_name).to be_a(String)
      end

      it 'sets records' do
        expect(processor.records).to eq([])
        expect(processor.records).to be_a(Array)
      end
    end
  end

  describe 'attribute readers and writers' do
    it 'allows reading but not writing of file name' do
      expect(processor).to respond_to(:file_name)
      expect(processor).to_not respond_to(:file_name=)
    end

    it 'allows reading but not writing of records' do
      expect(processor).to respond_to(:records)
      expect(processor).to_not respond_to(:records=)
    end
  end

  describe '#save_csv' do
    context 'when the method is called' do
      it 'saves the file' do
        expect(processor.save_csv).to eq([])
      end
    end
  end

  describe '#filter_by_error' do
    context 'when the method is called with valid parameters' do
      it 'returns an array of records with errors' do
        expect(processor.filter_by_error(error_type: :test_error)).to eq([])
        expect(processor.filter_by_error(error_type: :test_error)).to be_a(Array)
        expect(processor.filter_by_error(error_type: :test_error)).to be_empty
      end
    end
    context 'when the method is called with invalid parameters' do
      it 'raises an error' do
        expect { processor.filter_by_error(error_type: 'test') }.to raise_error(FileProcessor::IncorrectFormatError)
      end
    end
  end

  describe '#filter_by_name_count' do
    let(:records) do
      [['More than two first names',
        'Last name',
        'Address',
        'Years lived at address',
        'Passport number',
        'National insurance number'],
       ['Two Names',
        'Last name',
        'Address',
        'Years lived at address',
        'Passport number',
        'National insurance number']]
    end
    context 'when the method is called' do
      it 'returns an array of records with first names containing more than two words' do
        expect(processor.filter_by_name_count(records: records)).to eq(1)
        expect(processor.filter_by_name_count(records: records)).to be_a(Integer)
      end
    end
  end
end
