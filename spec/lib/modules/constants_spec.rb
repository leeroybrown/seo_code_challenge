# frozen_string_literal: true

RSpec.describe Constants do
  context 'FileHelper' do
    it 'should have a constant for the output directory' do
      expect(Constants::FileHelper::OUTPUT_DIR).to eq('output_data')
    end
  end

  it 'should have a constant for the output file headers' do
    expect(Constants::FileHelper::OUTPUT_HEADERS).to match_array(%w[firstNames lastName dateOfBirth Address
                                                                    yearsAtAddress passportNumber nationalInsuranceNumber errors])
  end
end
