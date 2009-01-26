
module Observable
  
  def observers()
    @observers = []
  end
  
  def register(observer)
    observers() if @observers == nil
    @observers << observer
  end
  
  def update_all(sender, message)
    @observers.each{|observer| observer.update(sender, message)}
  end
  
end
