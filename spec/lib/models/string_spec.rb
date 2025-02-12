RSpec.describe String do
  context '#capitalize_first_names' do
    it 'capitalizes the first letter of each name in a string' do
      expect('john doe'.capitalize_first_names).to eq('John Doe')
    end

    it 'does not capitalize non-first letters' do
      expect('john doe'.capitalize_first_names).not_to eq('john Doe')
    end
  end

  context '#capitalize_surname' do
    it 'capitalizes the first letter and letters following an apostrophe' do
      expect("o'o'o'gara".capitalize_surname).to eq("O'O'O'Gara")
    end
  end
end
