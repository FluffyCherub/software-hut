#--------------------------------------------------
# File for defining abilities(using cancancan gem)
#--------------------------------------------------
# Author: Dominik Laszczyk/Ling Lai
# Date: 10/04/2021
#--------------------------------------------------

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, module_privilege = "student")
    user ||= User.new

    if module_privilege == nil
      module_privilege = "no_privilege"
    end

    #check if user is not suspended(otherwise has no permission to do anything in the system)
    if !user.suspended

      #check if user is an admin(can manage every page)
      if user.admin?
        can :manage, :all
      else
        #privileges for module leader
        if module_privilege == "module_leader"
          can :manage, :admin_page
          can :manage, :admin_modules
          can :manage, :admin_modules_preview
          can :manage, :admin_modules_create
          can :manage, :admin_modules_edit
          can :manage, :admin_modules_privilege
          can :manage, :admin_modules_groups
          can :manage, :admin_modules_groups_preview
          can :manage, :admin_modules_groups_add
          can :manage, :admin_modules_groups_create
          can :manage, :add_remove_students_from_module
          can :manage, :admin_modules_periods_edit
          can :manage, :send_feedback_mailmerge
          can :manage, :approve_teams
          can :manage, :feedback_mailmerge_edit
        end

        #privileges for the student
        if module_privilege == "student"
          can :manage, :modules
          can :manage, :toa_doc
          can :manage, :tmr_doc
          can :manage, :student_groups_join
          can :manage, :student_profile
          can :manage, :student_profile_feedback_old
          can :manage, :student_profile_docs_old
        end

        #TEACHING ASSISTANT SECTION -----------------------------------------------------------
        #1 mail-merge feedback
        # can :manage, :send_feedback_mailmerge
        
        #2 teams with problems
        # can :manage, :admin_modules_groups

        #3 module edit/clone
        # can :manage, :admin_modules_edit

        #4 managing teams
        # can :manage, :admin_modules_groups
        # can :manage, :admin_modules_groups_preview
        # can :manage, :admin_modules_groups_add
        # can :manage, :admin_modules_groups_create
        # can :manage, :problems
        # can :manage, :add_remove_students_from_module
        # can :manage, :admin_modules_periods_edit
        # can :manage, :approve_teams

        if module_privilege.include? "teaching_assistant"
          can :manage, :admin_page
          can :manage, :admin_modules
          can :manage, :admin_modules_preview

         

          if module_privilege == "teaching_assistant_1"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge
          end

          if module_privilege == "teaching_assistant_2"
            #2teams with problems
            can :manage, :admin_modules_groups
          end

          if module_privilege == "teaching_assistant_3"
            #3module edit/clone
            can :manage, :admin_modules_edit
          end

          if module_privilege == "teaching_assistant_4"
            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
            can :manage, :admin_modules_periods_edit
            can :manage, :approve_teams
          end

          if module_privilege == "teaching_assistant_5"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge

            #2teams with problems
            can :manage, :admin_modules_groups
          end

          if module_privilege == "teaching_assistant_6"
            #2teams with problems
            can :manage, :admin_modules_groups

            #3module edit/clone
            can :manage, :admin_modules_edit
          end

          if module_privilege == "teaching_assistant_7"
            #3module edit/clone
            can :manage, :admin_modules_edit

            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
            can :manage, :admin_modules_periods_edit
            can :manage, :approve_teams
          end

          if module_privilege == "teaching_assistant_8"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge

            #3module edit/clone
            can :manage, :admin_modules_edit
          end

          if module_privilege == "teaching_assistant_9"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge

            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
          end

          if module_privilege == "teaching_assistant_10"
            #2teams with problems
            can :manage, :admin_modules_groups

            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
            can :manage, :admin_modules_periods_edit
            can :manage, :approve_teams
          end

          if module_privilege == "teaching_assistant_11"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge

            #2teams with problems
            can :manage, :admin_modules_groups

            #3module edit/clone
            can :manage, :admin_modules_edit
          end

          if module_privilege == "teaching_assistant_12"
            #2teams with problems
            can :manage, :admin_modules_groups

            #3module edit/clone
            can :manage, :admin_modules_edit

            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
            can :manage, :admin_modules_periods_edit
            can :manage, :approve_teams
          end

          if module_privilege == "teaching_assistant_13"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge

            #3module edit/clone
            can :manage, :admin_modules_edit

            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
            can :manage, :admin_modules_periods_edit
            can :manage, :approve_teams
          end

          if module_privilege == "teaching_assistant_14"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge

            #2teams with problems
            can :manage, :admin_modules_groups

            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
            can :manage, :admin_modules_periods_edit
            can :manage, :approve_teams
          end

          if module_privilege == "teaching_assistant_15"
            #1 mail-merge feedback
            can :manage, :send_feedback_mailmerge

            #2teams with problems
            can :manage, :admin_modules_groups

            #3module edit/clone
            can :manage, :admin_modules_edit

            #4managing teams
            can :manage, :admin_modules_groups
            can :manage, :admin_modules_groups_preview
            can :manage, :admin_modules_groups_add
            can :manage, :admin_modules_groups_create
            can :manage, :problems
            can :manage, :add_remove_students_from_module
            can :manage, :admin_modules_periods_edit
            can :manage, :approve_teams
          end

          if module_privilege == "teaching_assistant_16"
          end
        end

      end

    end
    
  end
end
