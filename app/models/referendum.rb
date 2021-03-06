class Referendum < ActiveRecord::Base

  # a hack to isolate locality referendums from other localities
  # as we don't have standardized referendum UIDs they duplicate on federal and state levels
  belongs_to :locality

  belongs_to :district
  has_many   :precincts, through: :district
  has_many   :ballot_responses, dependent: :destroy
  has_many   :contest_results, dependent: :destroy

end
