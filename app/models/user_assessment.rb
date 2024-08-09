class UserAssessment < ApplicationRecord
  belongs_to :user
  belongs_to :assessment
   
  has_many :user_results, dependent: :destroy

  #calculate scores
  # def calculate_score
  #   correct_answers = user_results.joins(:option).where(options: { is_right: true }).count
  #   total_questions = assessment.questions.count
  #   total_questions.zero? ? 0 : (correct_answers.to_f / total_questions) * 100
  # end
  def calculate_score
    correct_answers_count = user_results.where(correct: true).count
    total_questions = user_results.count
    score_percentage = total_questions.zero? ? 0 : (correct_answers_count.to_f / total_questions) * 100
    update(score: score_percentage)
    Rails.logger.debug "Score saved: #{score_percentage}"
    #score_percentage
  end
end
