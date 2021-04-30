#----------------------------------------------------------------
# Controller used for Actions related to notes added to problems
#----------------------------------------------------------------
# Author: Dominik Laszczyk
# Date: 27/04/2021
#----------------------------------------------------------------

class ProblemNotesController < ApplicationController

  #creating/displaying a problem note on the teams page
  def create
    @new_note = params['new_note']
    @problem_id = params['problem_id']
    @problem_number = params['problem_number']
    @team_number = params['team_number']

    @div_name = "#notes_id_" + @team_number.to_s + "_" + @problem_number

    #addding the note to the databse for the correct problem
    ProblemNote.create(created_by: current_user.username,
                      note: @new_note,
                      problem_id: @problem_id)
    
    #getting all the notes for the current problem
    @problem_notes = ProblemNote.get_notes_for_problem(@problem_id)
    
    #rendering all the notes with the new one on teams page
    respond_to do |format|
      format.js {render layout: false}
    end

  end
  
end
