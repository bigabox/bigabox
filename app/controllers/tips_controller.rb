class TipsController < ApplicationController
  def expert
    @tip = Tip.find(:first, :conditions => ['tip_type="Expert Tip"'])
    render :layout => false, :template => '/tips/tip' 
  end

  def ticket
     @tip = Tip.find(:first, :conditions => ['tip_type="Ticket Tip"'])
     render :layout => false, :template => '/tips/tip' 
  end

  def promote
     @tip = Tip.find(:first, :conditions => ['tip_type="Promote Tip"'])
     render :layout => false, :template => '/tips/tip' 
  end
  
end
