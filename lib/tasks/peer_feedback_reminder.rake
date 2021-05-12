namespace :peer_feedback_reminder do
  desc "Remind students to send feedback"
  task:remind => :environment do
    PeerFeedback.remind
  end

  desc "Inform students that a feedback period is open"
  task:period_open => :environment do
    PeerFeedback.feedback_period_open
  end
end