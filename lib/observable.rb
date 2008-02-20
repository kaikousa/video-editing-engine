
module Observable
  
  def observers()
    @observers = []
  end
  
  def register(observer)
    observers() if @observers == nil
    @observers << observer
  end
  
  def updateAll(message)
    @observers.each{|observer| observer.update(message)}
  end
  
end
