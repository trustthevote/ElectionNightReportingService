class ColorScheme

  def self.candidate_pre_color(party)
    if party == 'republican'
      c = 'republican'
    elsif party == 'democratic-farmer-labor' or party == 'democratic'
      c = 'democrat'
    elsif party == 'nonpartisan'
      c = nil # we'll have it idx-based
    else
      c = 'other'
    end

    c ? colors[c] : nil
  end

  def self.candidate_color(candidate, index)
    c = 'not_reporting'

    if candidate
      party = candidate.party.name.downcase.strip

      if party == 'nonpartisan'
        c = index == 0 ? 'nonpartisan1' : 'nonpartisan2'
      elsif party == 'republican'
        c = 'republican'
      elsif party == 'democratic-farmer-labor' or party == 'democratic'
        c = 'democrat'
      else
        c = 'other'
      end
    end

    colors[c]
  end

  def self.ballot_response_color(ballot_response, index)
    c = 'not_reporting'

    if ballot_response
      name = ballot_response.name.downcase.strip

      if name == 'yes'
        c = 'referenda_yes'
      elsif name == 'no'
        c = 'referenda_no'
      else
        c = index == 0 ? 'referenda_yes' : 'referenda_no'
      end
    end

    colors[c]
  end

  def self.special_colors(t)
    colors[t.to_s]
  end

  def self.colors
    @colors ||= AppConfig['map_color']['colors']
  end

end
