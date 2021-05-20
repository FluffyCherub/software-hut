# == Schema Information
#
# Table name: peer_feedbacks
#
#  id                :bigint           not null, primary key
#  appreciate        :string           default("")
#  appreciate_edited :string           default("")
#  attendance        :integer
#  attitude          :integer
#  collaboration     :integer
#  communication     :integer
#  created_by        :string
#  created_for       :string
#  ethics            :integer
#  leadership        :integer
#  qac               :integer
#  request           :string           default("")
#  request_edited    :string           default("")
#  status            :string           default("in_progress")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  feedback_date_id  :bigint
#
# Indexes
#
#  index_peer_feedbacks_on_feedback_date_id  (feedback_date_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_date_id => feedback_dates.id)
#
class PeerFeedback < ApplicationRecord
  belongs_to :feedback_date

  #convert text feedback to integer
  #takes feedback text as string, returns integer
  def self.feedback_to_int(feedback_text = nil)

    if feedback_text == "unsatisfactory"
      return 1
    elsif feedback_text == "needs_improvement"
      return 2
    elsif feedback_text == "meets_expectations"
      return 3
    elsif feedback_text == "exceeds_expectations"
      return 4
    else
      return nil
    end
  end

  #get feedback in array format with integers inside
  #takes created_by as string(username), created_for as string(username), and id of a feedback date object
  #returns array of integers(feedback)
  def self.get_feedback_array_for_user(created_by, created_for, feedback_date_id)
    feedback = PeerFeedback.where(created_by: created_by,
                                  created_for: created_for,
                                  feedback_date_id: feedback_date_id)

    if feedback.length == 0
      return nil
    else
      return feedback.pluck(:attendance, :attitude, :qac, :communication, :collaboration, :leadership, :ethics)[0]
    end

  end

  #get feedback object for student
  #takes created_by as string(username), created_for as string(username), and id of a feedback date object
  #returns PeerFeedback object
  def self.get_feedback_for_user(created_by, created_for, feedback_date_id)
    feedback = PeerFeedback.where(created_by: created_by,
                                  created_for: created_for,
                                  feedback_date_id: feedback_date_id)

    if feedback.length == 0
      return nil
    else
      return feedback
    end

  end

  #get feedback objects for user
  #takes created_for as string(username), and id of a feedback date object
  #returns PeerFeedback object
  def self.get_feedback_for_user_by_date(created_for, feedback_date_id)
    feedback = PeerFeedback.where(created_for: created_for,
                                  feedback_date_id: feedback_date_id)

    if feedback.length == 0
      return nil
    else
      return feedback
    end
  end

  #check if feedback is completed for feedback period
  #takes list of student objects, created_by as string(username) and id of feedback date object
  #returns true or false
  def self.check_feedback_completion(students_list, created_by, feedback_date_id)

    feedback_completed = true

    for i in 0...students_list.length
      current_feedback = PeerFeedback.where(created_by: created_by,
                                            created_for: students_list[i].username,
                                            feedback_date_id: feedback_date_id).first


      if current_feedback.nil?
        feedback_completed = false
        break
      end
      
      if current_feedback.status == "in_progress"
        feedback_completed = false
        break
      end
    end

    return feedback_completed

  end

  #get feedback for a certain feedback period for a team
  #takes team id and feedback date id
  #returns array of PeerFeedback objects
  def self.get_feedback_for_team_period(team_id, feedback_date_id)
    team_members = Team.get_current_team_members(team_id)

    result = []

    #get feedback for every team member
    for i in 0...team_members.length
      feedback_for_current_team_member = PeerFeedback.get_feedback_for_user_by_date(team_members[i].username, feedback_date_id)

      result.append(feedback_for_current_team_member)
    end

    return result
  end

  def self.array_int_to_feedback(feedback_int_array)
    result = []
    for i in 0...feedback_int_array.length
      if feedback_int_array[i] == 1
        result.append("Unsatisfactory") 
      elsif feedback_int_array[i] == 2
        result.append("Needs Improvement")
      elsif feedback_int_array[i] == 3
        result.append("Meets Expectations")
      elsif feedback_int_array[i] == 4
        result.append("Exceeds Expectations")
      else
        result.append(nil)
      end
    end
    
    return result
  end

  def self.array_int_to_feedback_long(feedback_int_array)
    attendance = ["Attendance and Punctuality",
    "You have had one of more absences or late arrivals to scheduled team activities and have not explained these to the team. You may have let other commitments impact your contribution. Your performance is detracting from the team’s work.",
    "You have had one or more absences or late arrivals to scheduled team activities and could have done a better job of notifying the team in advance. Your absence has not yet caused significant harm to the team, but you need to improve.", 
    "You have been prompt and attended every team event, or have excused yourself with good reason. If you have been absent, you have caught up with another group member as soon as possible.", 
    "You have been prompt and attended every team event, or have excused yourself with good reason. You have planned ahead for absences (such as interviews or medical appointments) and/or busy periods in your schedule with other deadlines, to ensure that they do not adversely affect the team."]
    attitude = ["Attitude and Commitment",
    "You usually bring a negative attitude to the team, are unfocused, and do not make much effort. Your lack of commitment has created a burden for the team, and/or has required changes in the schedule to ensure we can still meet the deadline.",
    "You sometimes bring a negative attitude to the team, and can lack focus. You sometimes do not try as hard as you could. You you are not undertaking your fair share of the workload and/or are not producing work to the agreed schedule.",
    "You bring a positive attitude to the team, are generally focused, and work hard most of the time. You you are undertaking your fair share of the workload, and complete work to the agreed schedule.",
    "You bring a very positive attitude to the team, are focused, and consistently give your best. You you are undertaking your fair share of the workload and may be assisting others with their contributions. You complete work on time or ahead of schedule."]
    qac = ["Quality, accuracy and completeness",
    "You have not completed your contributions, or your work is clearly insufficient, incomplete, or contains basic inaccuracies. The team cannot proceed without completing this work or re-doing it entirely.",
    "You have not made as much progress as you could have done with your contributions. Work that has been completed is on the right lines, but needs checking for basic errors. You need to put in extra effort to complete work to the standard agreed in our team vision/mission.",
    "You have completed or made solid progress on all of your contributions and they are sufficient and mostly error-free. If anything is incomplete, it is because you have identified valid problems or questions. You have clearly put effort into making the work of the standard agreed in our team vision/mission.",
    "You have completed all of your contributions and they are accurate, and essentially in final form. If anything is incomplete, it is because you identified valid problems or questions, and raised these with the team as soon as possible. Your work clearly meets or exceeds the standard agreed in our team vision/mission."]
    communication = ["Communication",
    "You do not contribute to discussions, and/or fail to reply to messages appropriately. You do not listen to others. Your not communicating effectively means the team lacked important information or hit problems that you could have prevented.",
    "Your contribution is patchy with minimal input to discussions and generally poor responses to messages. You do not always listen effectively to others, and need to think about how you share important information the rest of the team needs to succeed.",
    "You communicate well with the team in meetings and via messages, mostly sharing your ideas clearly. You listen to others effectively and respectfully. You actively ensure you keep everyone up-to-date on your aspects of the work.",
    "Your communication is excellent both orally and in writing. You listen to others effectively and respectfully, and regularly check your and the group’s understanding. You proactively ensure that everyone is up-to-date and shares important information."]
    collaboration = ["Collaboration",
    "You are frequently rude to others, and work in isolation without consulting the team on your contributions. You do not offer feedback to others, and react negatively if you receive feedback from your team. You cause conflicts within the team and take no responsibility for helping the team work together.",
    "You come across abrupt and offhand, and tend to work in isolation without consulting the team. You are not receptive to feedback from others. You may sometimes cause conflicts within the team and could do more to help the team work together.",
    "You are polite and courteous to others, and dedicated to the team. You encourage other members of the team, sometimes providing supportive feedback. You try to respond to feedback that others give to you. You make a positive contribution to team harmony.",
    "You go above and beyond to help and encourage others. You actively provide praise and constructive criticism to help others make their best contribution. You seek and take account of feedback on your own contributions. You actively help to navigate team disagreements positively."]
    leadership = ["Leadership",
    "You made no contribution to the direction of the team, by not engaging in setting team goals and not getting involved in idea generation or problem solving.",
    "You did not make much contribution to setting team goals, and focus on your own contributions rather than the overall objectives. Your input to idea generation and problem solving is minimal.",
    "You have supported the team to set and achieve goals, and helped to keep track of activity and progress. You contributed to idea generation for the team and helped with problem-solving.",
    "You actively helped to establish a team vision and goals, and support the team to achieve these. You play a significant role in keeping the team on task, monitoring progress. You made a big contribution to idea generation and problem-solving."]
    ethics = ["Professionalism and ethics",
    "You have ignored your academic/professional responsibilities, e.g. by committing plagiarism, or behaving inappropriately or in a way that reflects negatively on the team. Your actions could cause the whole team to fail.",
    "You have overlooked some academic/professional responsibilities, perhaps omitting references, or making remarks that have been offensive to a team member or other individual. You need to think about the impact of your behaviour on others.",
    "You behave responsibly and in line with your academic/professional responsibilities, ensuring work is referenced appropriately, and that your actions do not negatively impact others.",
    "You are a role model for others, behaving professionally and ethically even in difficult circumstances. You take great care to ensure that your interactions with others are positive and do not have a negative impact."]
  
    result = []

    for i in 1...feedback_int_array.length
      if feedback_int_array[i] != (-1)
        case i
        when 1
          case feedback_int_array[1]
          when 1
            result.append([attendance[0], attendance[1]])
          when 2
            result.append([attendance[0], attendance[2]])
          when 3
            result.append([attendance[0], attendance[3]])
          when 4
            result.append([attendance[0], attendance[4]])
          end
        when 2
          case feedback_int_array[2]
          when 1
            result.append([attitude[0], attitude[1]])
          when 2
            result.append([attitude[0], attitude[2]])
          when 3
            result.append([attitude[0], attitude[3]])
          when 4
            result.append([attitude[0], attitude[4]])
          end
        when 3
          case feedback_int_array[3]
          when 1
            result.append([qac[0], qac[1]])
          when 2
            result.append([qac[0], qac[2]])
          when 3
            result.append([qac[0], qac[3]])
          when 4
            result.append([qac[0], qac[4]])
          end
        when 4
          case feedback_int_array[4]
          when 1
            result.append([communication[0], communication[1]])
          when 2
            result.append([communication[0], communication[2]])
          when 3
            result.append([communication[0], communication[3]])
          when 4
            result.append([communication[0], communication[4]])
          end
        when 5
          case feedback_int_array[5]
          when 1
            result.append([collaboration[0], collaboration[1]])
          when 2
            result.append([collaboration[0], collaboration[2]])
          when 3
            result.append([collaboration[0], collaboration[3]])
          when 4
            result.append([collaboration[0], collaboration[4]])
          end
        when 6
          case feedback_int_array[6]
          when 1
            result.append([leadership[0], leadership[1]])
          when 2
            result.append([leadership[0], leadership[2]])
          when 3
            result.append([leadership[0], leadership[3]])
          when 4
            result.append([leadership[0], leadership[4]])
          end
        when 7
          case feedback_int_array[7]
          when 1
            result.append([ethics[0], ethics[1]])
          when 2
            result.append([ethics[0], ethics[2]])
          when 3
            result.append([ethics[0], ethics[3]])
          when 4
            result.append([ethics[0], ethics[4]])
          end
        
        end
      else
        if i == 1
          result.append([attendance[0], "You received no feedback for this criteria."])
        end

        if i == 2
          result.append([attitude[0], "You received no feedback for this criteria."])
        end

        if i == 3
          result.append([qac[0], "You received no feedback for this criteria."])
        end

        if i == 4
          result.append([communication[0], "You received no feedback for this criteria."])
        end

        if i == 5
          result.append([collaboration[0], "You received no feedback for this criteria."])
        end

        if i == 6
          result.append([leadership[0], "You received no feedback for this criteria."])
        end

        if i == 7
          result.append([ethics[0], "You received no feedback for this criteria."])
        end
          
      end
    end
    
    return result
  
    end

  
    def self.get_average_feedback_data(username, team_id)
    #get all team members for the selected team
    team_members = User.joins(:teams)
                        .where("teams.id = ?",
                                team_id)

    #get all team members without the current user
    team_members_without_current_user = User.joins(:teams)
                                              .where("teams.id = ? AND
                                                      users.username != ?",
                                                      team_id,
                                                      username)

    
    #store team members usernames in an array
    teams_members_usernames = team_members_without_current_user.pluck(:username)

    #get feedback periods fot this team
    f_periods = FeedbackDate.joins(:teams).where("teams.id = ?", team_id)
    num_of_periods = f_periods.length

    #array for storing all the feedback averages
    width = f_periods.length
    height = 7
    average_feedback_data = Array.new(height){Array.new(width)}

    #average of averages for every periods
    average_for_every_period = Array.new(f_periods.length)

    #get feedback data for every period and calculate the averages
    for k in 0...f_periods.length

      current_feedback_data = PeerFeedback.where("created_for = ? AND
                                                  created_by IN (?) AND
                                                  feedback_date_id = ?",
                                                  username,
                                                  teams_members_usernames,
                                                  f_periods[k].id)
                                          .pluck(:attendance, :attitude, :qac, :communication, :collaboration, :leadership, :ethics)

      #calculating average data for every on of the seven criteria
      for z in 0...7
        data_for_one_criteria = current_feedback_data.collect {|ind| ind[z]}
        average_data_for_one_criteria = data_for_one_criteria.inject{ |sum, el| sum + el }.to_f / data_for_one_criteria.size

        average_feedback_data[z][k] = average_data_for_one_criteria
      end

    end

    #loop through the averages and get the ultimate average
    for z in 0...f_periods.length
      data_for_one_criteria = average_feedback_data.collect {|ind| ind[z]}
      average_data_for_one_criteria = data_for_one_criteria.inject{ |sum, el| sum + el }.to_f / data_for_one_criteria.size

      average_for_every_period[z] = (average_data_for_one_criteria)
    end
    
    #adding the average of averages to the other averages
    average_feedback_data.prepend(average_for_every_period)

    #averages for every criteria for all periods combined
    average_overall = []

    for k in 0...average_feedback_data.length
      current_data_row = average_feedback_data[k]
      average_overall.append(current_data_row.inject{ |sum, el| sum + el }.to_f / current_data_row.size)
    end

    #rounding the overall average
    for i in 0...average_overall.length
      if !average_overall[i].nan?
        average_overall[i] = average_overall[i].round()
      end
    end

    return average_feedback_data, num_of_periods, average_overall, team_members_without_current_user, team_members
  end

  def self.get_average_feedback_data_for_period(username, team_id, feedback_date)
    #get all team members for the selected team
    team_members = User.joins(:teams)
                        .where("teams.id = ?",
                                team_id)

    #get all team members without the current user
    team_members_without_current_user = User.joins(:teams)
                                            .where("teams.id = ? AND
                                                    users.username != ?",
                                                    team_id,
                                                    username)

    
    #store team members usernames in an array
    teams_members_usernames = team_members_without_current_user.pluck(:username)

    #get feedback periods fot this team
    f_periods = FeedbackDate.joins(:teams).where("teams.id = ?", team_id)
    num_of_periods = f_periods.length

    #array for storing all the feedback averages
    height = 7
    average_feedback_data = Array.new(height)


    #get feedback data for chosen period and calculate the averages
    current_feedback_data = PeerFeedback.where("created_for = ? AND
                                                created_by IN (?) AND
                                                feedback_date_id = ?",
                                                username,
                                                teams_members_usernames,
                                                feedback_date.id)
                                        .pluck(:attendance, :attitude, :qac, :communication, :collaboration, :leadership, :ethics)

    #calculating average data for every one of the seven criteria
    for z in 0...7
      data_for_one_criteria = current_feedback_data.collect {|ind| ind[z]}
      average_data_for_one_criteria = data_for_one_criteria.inject{ |sum, el| sum + el }.to_f / data_for_one_criteria.size

      average_feedback_data[z] = average_data_for_one_criteria
    end

    #loop through the averages and get the ultimate average
    average_for_every_period = average_feedback_data.inject{ |sum, el| sum + el }.to_f / average_feedback_data.size

    #adding the average of averages to the other averages
    average_feedback_data.prepend(average_for_every_period)

    #rounding all the averages
    #average_feedback_data = average_feedback_data.map { |average| average.round() }
    for t in 0...average_feedback_data.length
      if average_feedback_data[t].nan? == false
        average_feedback_data[t] = average_feedback_data[t].round()
      else
        average_feedback_data[t] = (-1)
      end
    end

    
    return average_feedback_data
    
  end

  def self.get_appreciate_request_for_student(username, team_id, feedback_date_id)
    appreciate_array = []
    request_array = []

    #get all team members without the current user
    team_members_without_current_user = User.joins(:teams)
                                            .where("teams.id = ? AND
                                                    users.username != ?",
                                                    team_id,
                                                    username)

    for i in 0...team_members_without_current_user.length
      p_feedback_for_student = PeerFeedback.where(created_for: username,
                                                  created_by: team_members_without_current_user[i].username,
                                                  feedback_date_id: feedback_date_id).first

      appreciate_array.append(p_feedback_for_student.appreciate_edited)
      request_array.append(p_feedback_for_student.request_edited)
    end

    return appreciate_array, request_array
    
  end

  #reminds students to do the peer feedback matrix one day before the deadline
  def self.remind

    #get feedback periods which need reminders sent
    f_periods = FeedbackDate.where("feedback_dates.end_date < ? AND feedback_dates.end_date > ? AND reminder_sent = ?", Time.now + 1.days, Time.now, false)
    
    for i in 0...f_periods.length
      #get all teams connected to the current feedback period
      teams_to_remind = Team.joins(:feedback_dates).where("feedback_dates.id = ?", f_periods[i].id)

      #get module info
      module_info = ListModule.find(f_periods[i].list_module_id)

      for j in 0...teams_to_remind.length

        team_members = User.joins(:teams).where("teams.id = ?", teams_to_remind[j].id)
        for k in 0...team_members.length
          email = team_members[k].email
          receiver_full_name = team_members[k].givenname + " " + team_members[k].sn
          feedback_date = f_periods[i]
          team_info = teams_to_remind[j]

          gave_feedback = true
          
          for z in 0...team_members.length
            if k != z
              feedback = PeerFeedback.where(created_for: team_members[z].username, created_by: team_members[k].username).first
              if feedback.nil? || feedback.status != "finished"
                gave_feedback = false
              end
            end
          end 

          #here email user
          if gave_feedback == true
            UserMailer.peer_feedback_reminder(email, receiver_full_name, feedback_date, team_info, module_info).deliver
            f_periods[i].update(reminder_sent: true)
          end

        end
      end 
    end
  end

  def self.feedback_period_open
    #get feedback periods that are currently going
    f_periods = FeedbackDate.where("start_date < ? AND end_date > ? AND period_open_sent = ?", Time.now, Time.now, false)

    #loop thorugh all periods that are currently going on
    for i in 0...f_periods.length

      #get module connected to the current feedback date object
      module_info = ListModule.find(f_periods[i].list_module_id)

      students = FeedbackDate.get_all_connected_students(f_periods[i].id)

      for j in 0...students.length
        email = students[j].email
        receiver_full_name = students[j].givenname + " " + students[j].sn
        feedback_date = f_periods[i]

        #send email
        UserMailer.peer_feedback_open(email, receiver_full_name, feedback_date, module_info).deliver
        f_periods[i].update(period_open_sent: true)
      end
      
    end
  end
end
