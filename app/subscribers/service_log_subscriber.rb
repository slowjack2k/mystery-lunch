class ServiceLogSubscriber < ActiveSupport::LogSubscriber
  def pair_employees(event)
    payload = event.payload
    exception = payload[:exception]

    if exception
      exception_object = event.payload[:exception_object]

      error {
        "[ERROR] during pairing #{event.payload[:name]}: #{exception.join(", ")} with: #{payload[:retries]} " \
              "(#{exception_object.backtrace.first})"
      }
    else
      info { "[INFO] paired employees: #{payload[:count]}, retries: #{payload[:retries]}, in #{payload[:runtime].round}ms" }
    end
  end
end
