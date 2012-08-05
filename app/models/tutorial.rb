class Tutorial < ActiveRecord::Base  
  
   def get_current_tutorial
    current_tutorial = {}
    self.target = ''
    TUTORIAL.each do |tutorial_elem|
      unless self.completed.include?(tutorial_elem[0].to_s)
        current_tutorial[:instruction] = tutorial_elem[1]['instruction']
        self.target = tutorial_elem[0].to_s
        break
      end
    end
    if self.target.blank?
      return current_tutorial
    end
    unless self.show_success_for.blank?
      current_tutorial[:summary] = TUTORIAL[self.show_success_for]['summary']
      current_tutorial[:show_success_for] = self.show_success_for
    end
    unless self.show_discovered_for.blank?
      current_tutorial[:summary] = TUTORIAL[self.show_discovered_for]['summary']
      current_tutorial[:show_discovered_for] = self.show_discovered_for
    end
    unless self.show_summary.blank?
      current_tutorial[:completed_summary] = self.completed
    end
    return current_tutorial
  end
  
  def adjust_tutorial(match)
    self.show_success_for = ''
    self.show_discovered_for = ''
    self.show_summary = ''
    unless match.blank?
      unless self.completed.include?(match)
        if TUTORIAL[self.target]['matches'].split(',').include?(match)
          self.completed = self.completed + ',' unless self.completed.blank?
          self.completed = self.completed + self.target.to_s
          self.show_success_for = self.target.to_s
        else
          TUTORIAL.each do |tutorial_elem|  
            if tutorial_elem[0].to_s.casecmp(match) == 0
              unless self.completed.include?(match)
                self.completed = self.completed + ',' unless self.completed.blank?
                self.completed = self.completed + match
                self.show_discovered_for = match
              end
            end
          end
        end
      end
    end
  end
  
  def setup_return_visit_settings
    self.show_success_for = ''
    self.show_discovered_for = ''
    self.show_summary = 'true'
  end

end