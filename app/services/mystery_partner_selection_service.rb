class MysteryPartnerSelectionService
  def self.call(**args)
    new(**args).call
  end

  def initialize(employees_by_department:)
    @employees_by_department = employees_by_department.dup
  end

  def call
    instrument "pair_employees" do
      with_retries(5, DepartmentsContainer::IllegalCombinationError) do
        departments = employees_by_department.each_with_object({}) do |(department, employees), result_hash|
          result_hash[department] = Department.new employees: employees
        end
        DepartmentsContainer.new(departments: departments).pairings
      end
    end
  end

  private

  def with_retries(cnt, exception, &block)
    @retries = 0
    begin
      block.call
    rescue exception
      retry if (@retries += 1) < cnt
    end
  end

  def instrument(event, &block)
    count = employees_by_department.values.sum { |ids| ids.size }
    ActiveSupport::Notifications.instrument "#{event}.service", count: count do |payload|
      result = nil

      runtime = Benchmark.ms { result = block.call }

      payload[:runtime] = runtime
      payload[:retries] = @retries

      result
    end
  end

  attr_reader :employees_by_department
end
