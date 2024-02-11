class Voter < ActiveRecord::Base
  rcrm_acts_as_voter
end

class Votable < ActiveRecord::Base
  rcrm_acts_as_votable
  validates_presence_of :name
end

class VotableVoter < ActiveRecord::Base
  rcrm_acts_as_votable
  rcrm_acts_as_voter
end

class StiVotable < ActiveRecord::Base
  rcrm_acts_as_votable
end

class ChildOfStiVotable < StiVotable
end

class StiNotVotable < ActiveRecord::Base
  validates_presence_of :name
end

class VotableChildOfStiNotVotable < StiNotVotable
  rcrm_acts_as_votable
end

class VotableCache < ActiveRecord::Base
  rcrm_acts_as_votable
  validates_presence_of :name
end
