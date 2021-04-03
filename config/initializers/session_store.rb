Rails.application.config.session_store :active_record_store, key: (Rails.env.production? ? '_teamworks_session_id' : (Rails.env.demo? ? '_teamworks_demo_session_id' : '_teamworks_dev_session_id')),
                                                             secure: (Rails.env.demo? || Rails.env.production?),
                                                             httponly: true


