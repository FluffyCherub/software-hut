# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, module_privilege = "student")
    user ||= User.new

    if !user.suspended
      if user.admin?
        can :manage, :all
      end
  
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
      end

      if module_privilege == "student"
        can :manage, :modules
        can :manage, :toa_doc
        can :manage, :tmr_doc
      end

      #privileges for all kinds of teaching assistants
      #1mail feedback

      #2problems

      #3module edit/clone
      # can :manage, :admin_modules
      # can :manage, :admin_modules_preview
      # can :manage, :admin_modules_edit


      #4managing teams
      # can :manage, :admin_modules
      # can :manage, :admin_modules_preview
      # can :manage, :admin_modules_groups
      # can :manage, :admin_modules_groups_preview
      # can :manage, :admin_modules_groups_add
      # can :manage, :admin_modules_groups_create


      if module_privilege == "teaching_assistant_1"
        
      end

      if module_privilege == "teaching_assistant_2"
        
      end

      if module_privilege == "teaching_assistant_3"
        
      end

      if module_privilege == "teaching_assistant_4"
        
      end

      if module_privilege == "teaching_assistant_5"
        
      end

      if module_privilege == "teaching_assistant_6"
        
      end

      if module_privilege == "teaching_assistant_7"
        
      end

      if module_privilege == "teaching_assistant_8"
        
      end

      if module_privilege == "teaching_assistant_9"
        
      end

      if module_privilege == "teaching_assistant_10"
        
      end

      if module_privilege == "teaching_assistant_11"
        
      end

      if module_privilege == "teaching_assistant_12"
        
      end

      if module_privilege == "teaching_assistant_13"
        
      end

      if module_privilege == "teaching_assistant_14"
        
      end

      if module_privilege == "teaching_assistant_15"
        
      end

      if module_privilege == "teaching_assistant_16"
        
      end


    end

    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
