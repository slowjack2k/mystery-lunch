require Rails.root + "app/subscribers/service_log_subscriber"
ServiceLogSubscriber.attach_to :service
