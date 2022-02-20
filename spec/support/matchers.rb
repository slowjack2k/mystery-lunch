# credit: https://stackoverflow.com/questions/35628342/rspec-capybara-testing-a-page-for-a-table
RSpec::Matchers.define :contain_table do |expected|
  match do |page|
    expected = parse_md_table(expected)
    @actual = table(page) # for diffable

    compare_tables(@actual, expected)
  end

  def compare_tables(extracted_table, expected_table)
    equal = true
    expected_table.each_with_index do |row, row_num|
      row.each_with_index do |col, col_num|
        next if col == "*"

        actual_col = extracted_table[row_num][col_num].delete("\n").gsub(/\s+/, " ").strip

        content_matches = col == actual_col
        puts "'#{col}' <=> '#{actual_col}'" unless content_matches
        equal &&= content_matches
      end
    end

    equal
  end

  def parse_md_table(table)
    table.split("\n").map do |row|
      row.sub!(/^\|/, "")
      row.sub!(/\|$/, "")
      row.split(/\s*(?<!\\)\|\s*/).map { |col| col.gsub('\|', "|").strip }
    end
  end

  def table(page)
    document = Nokogiri::HTML(page.body)
    tables = document.xpath("//table").collect { |table| table.xpath(".//tr").collect { |row| row.xpath(".//th|td") } }
    table = tables.first

    table.each_with_object([]) do |row, rows|
      rows << row.each_with_object([]) do |col, result|
        result << col.text
      end
    end
  end

  diffable
end

RSpec::Matchers.define :contain_cards_with do |expected|
  match do |page|
    @actual = expected.map { |card_data| card_texts(page, card_data[:identifier]) }.compact

    return false unless @actual.size == expected.size

    expected.all? do |card_data|
      actual_card_texts = card_texts(page, card_data[:identifier])
      actual_card_texts.present? && card_data[:data].all? { |expected_text| actual_cards_contains?(actual_card_texts, expected_text) }
    end
  end

  def actual_cards_contains?(actual_card_texts, expected_text)
    actual_card_texts.any? { |text| text.include?(expected_text) }
  end

  def card_texts(page, identifier)
    document = Nokogiri::HTML(page.body)
    cards = document.css(".card .#{identifier} .card-body")
    cards&.map(&:text).presence
  end

  diffable
end
