class HolidaySearch 
  def upcoming_holidays
    service.all_upcoming_holidays[0..2].map do |data|
      Holiday.new(data)
    end
  end

  def service 
    NagerService.new
  end
end