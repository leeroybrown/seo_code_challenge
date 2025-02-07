RSpec.describe Validation do
  # Create a test class that includes the module
  let(:dummy_class) { Class.new { extend Validation } }

  describe '#character_limit_exceeded?' do
    context 'when name is within limit' do
      it 'returns false for empty string' do
        expect(dummy_class.character_limit_exceeded?(name: '')).to be false
      end

      it 'returns false for name within 45 characters' do
        valid_random_number = rand(1..45)
        name = 'a' * valid_random_number
        expect(dummy_class.character_limit_exceeded?(name: name)).to be false
      end

      it 'returns false for typical name' do
        expect(dummy_class.character_limit_exceeded?(name: 'John Smith')).to be false
      end
    end

    context 'when name exceeds limit' do
      it 'returns true for name exceeding 45 characters' do
        invalid_random_number = rand(46..99_999)
        name = 'a' * invalid_random_number
        expect(dummy_class.character_limit_exceeded?(name: name)).to be true
      end

      it 'returns true for very long name' do
        name = 'This is a very long name that should exceed the character limit'
        expect(dummy_class.character_limit_exceeded?(name: name)).to be true
      end
    end
  end

  describe '#characters_valid?' do
    context 'with valid names' do
      it 'returns true for simple names' do
        expect(dummy_class.characters_valid?(name: 'John')).to be true
      end

      it 'returns true for names with spaces' do
        expect(dummy_class.characters_valid?(name: 'John Smith')).to be true
      end

      it 'returns true for names with permitted special characters' do
        expect(dummy_class.characters_valid?(name: "O'Connor-Smith")).to be true
        expect(dummy_class.characters_valid?(name: 'Mary-Jane')).to be true
        expect(dummy_class.characters_valid?(name: 'St. John')).to be true
      end
    end

    context 'with invalid names' do
      it 'returns false for names starting with special characters' do
        expect(dummy_class.characters_valid?(name: "'John")).to be false
        expect(dummy_class.characters_valid?(name: '-Smith')).to be false
        expect(dummy_class.characters_valid?(name: '.John')).to be false
      end

      it 'returns false for names ending with special characters' do
        expect(dummy_class.characters_valid?(name: "John'")).to be false
        expect(dummy_class.characters_valid?(name: 'Smith-')).to be false
        expect(dummy_class.characters_valid?(name: 'John.')).to be false
      end

      it 'returns false for names with invalid special characters' do
        expect(dummy_class.characters_valid?(name: 'John@Smith')).to be false
        expect(dummy_class.characters_valid?(name: 'John123')).to be false
        expect(dummy_class.characters_valid?(name: 'Smith#Jones')).to be false
      end

      it 'returns false for empty string' do
        expect(dummy_class.characters_valid?(name: '')).to be false
      end
    end
  end

  describe '#check_age' do
    context 'when calculating age' do
      before do
        allow(Date).to receive(:today).and_return(Date.new(2024, 3, 1))
      end

      it 'calculates age correctly when birthday has not occurred this year' do
        date_of_birth = Date.new(1990, 12, 25)
        expect(dummy_class.check_age(date_of_birth: date_of_birth)).to eq(33)
      end

      it 'calculates age correctly when birthday has occurred this year' do
        date_of_birth = Date.new(1990, 2, 1)
        expect(dummy_class.check_age(date_of_birth: date_of_birth)).to eq(34)
      end

      it 'calculates age correctly when birthday is today' do
        date_of_birth = Date.new(1990, 3, 1)
        expect(dummy_class.check_age(date_of_birth: date_of_birth)).to eq(34)
      end

      it 'handles leap year birthdates' do
        date_of_birth = Date.new(1996, 2, 29)
        expect(dummy_class.check_age(date_of_birth: date_of_birth)).to eq(28)
      end
    end
  end
end

