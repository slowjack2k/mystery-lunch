class MysteryPartnerSelectionService
  def self.call(**args)
    new(**args).call
  end

  def initialize(year:, month:)
    @year = year
    @month = month
  end

  def call
    instrument "pair_employees" do
      with_retries(5, DepartmentsContainer::IllegalCombinationError) do
        departments = employees_by_department.each_with_object({}) do |(department, employees), result_hash|
          result_hash[department] = Department.new employees: employees
        end
        DepartmentsContainer.new(departments: departments).pairings
      end.tap do |pairings|
        store_pairings pairings
      end
    end
  end

  private

  def employees_by_department
    @employees_by_department ||= prepare_dataset
  end

  def prepare_dataset
    res = Employee::DEPARTMENTS.each_with_object({}) { |department, res| res[department] = [] }

    Employee.includes(:participations).all.each_with_object(res) do |employee, res|
      res[employee.department].push employee
    end
  end

  def store_pairings(pairings)
    Lunch.transaction do
      lunch = Lunch.create! year: year, month: month

      pairings.each do |employees|
        build_participants(lunch, employees)
      end

      bulk_insert_participants(lunch.participants)
    end
  end

  def build_participants(lunch, employees)
    lunch_group = FFaker::HipsterIpsum.sentence(10) + employees.map(&:id).join(" - ")

    employees.each do |employee|
      lunch.participants.build lunch_group: lunch_group,
        employee: employee,
        created_at: lunch.created_at,
        updated_at: lunch.updated_at
    end
  end

  def bulk_insert_participants(participants)
    new_records = participants.map(&:attributes).map { |record|
      record.delete(:id)
      record
    }

    raise unless participants.all?(&:valid?)

    Participant.insert_all! new_records
  end

  def with_retries(cnt, exception, &block)
    @retries = 0
    begin
      block.call
    rescue exception
      retry if (@retries += 1) < cnt
    end
  end

  def instrument(event, &block)
    ActiveSupport::Notifications.instrument "#{event}.service" do |payload|
      payload[:count] = employees_by_department.values.sum { |ids| ids.size }

      result = nil

      runtime = Benchmark.ms { result = block.call }

      payload[:runtime] = runtime
      payload[:retries] = @retries

      result
    end
  end

  attr_reader :year, :month
end
