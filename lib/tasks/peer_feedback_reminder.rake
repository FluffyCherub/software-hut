namespace :peer_feedback_reminder do
  desc "Remind students to send feedback"
  task:remind => :environment do
    PeerFeedback.remind
  end
end