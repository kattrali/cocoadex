class String
  def underscore
    gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def clean_markup
    gsub(/(\n|\t|\r)/, ' ').
    gsub(/>\s*</, '><').
    squeeze(' ')
  end
end