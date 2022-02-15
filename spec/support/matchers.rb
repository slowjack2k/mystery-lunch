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
        content_matches = col == extracted_table[row_num][col_num]
        puts "'#{col}' <=> '#{extracted_table[row_num][col_num]}'" unless content_matches
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
