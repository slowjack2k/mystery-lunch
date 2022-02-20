class ApplicationService
  def self.call(**args)
    new(**args).call
  end

  def initialize(**_args)
    super()
  end

  private

  def before_instrument(_payload)
  end

  def after_instrument(_payload)
  end

  def instrument(event, &block)
    ActiveSupport::Notifications.instrument "#{event}.service" do |payload|
      before_instrument(payload)

      result = nil

      runtime = Benchmark.ms { result = block.call }

      payload[:runtime] = runtime

      after_instrument(payload)

      result
    end
  end
end
