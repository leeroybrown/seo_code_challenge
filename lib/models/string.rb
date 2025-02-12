require 'capitalize_names'

class String
  def capitalize_first_names
    CapitalizeNames.capitalize(self)
  end

  def capitalize_surname
    if self.chars.include?("'")
      self.split("'").map(&:capitalize).join("'")
    else
      self.capitalize
    end
  end
end
