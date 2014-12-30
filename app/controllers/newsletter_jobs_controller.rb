class NewsletterJobsController < ApplicationController
  
   ############
  
  #Method Name : Index
  #Parameter : 
  #Return : attendi_send_mails
  #use : To Check repited multiple values to show only one time (updateA or updateO)
  
  ###########
  
  def index
  
   @newscp=NewsletterJob.select('DISTINCT newstype')  # To Display DISTINCT newstype values
    
    @newscp.each do |show|                   # to add only single entry
        attendi_send_mails(show[:newstype])  # to call attendi_send_mails function
    end

  end

 #def send_mail_test
 #	@now_date = DateTime.now.strftime('%Y-%m-%d %H:%M')
 #	render :text => @now_date and return 
 #end
  
  ############
  
  #Function Name : attendi_send_mails (Private Function)
  #Parameter : newstype
  #Return : @emailp
  #use : newstype Parameter Fetches data (updateA or updateO) from index method. This function return List of User depending on Email Preferences
  
  ###########
  
  private
  def attendi_send_mails(newstype)	# Create one private function
  
   @now_date = DateTime.now.strftime('%Y-%m-%d %H:%M')		# Show Currunt Date And Time
   @enddate = DateTime.now + 15.minutes				# To Check Currunt Time to  add 15 min
   @enddate = @enddate.strftime('%Y-%m-%d %H:%M')		# end Show end date (Currunt time + 15 min )
   @news = NewsletterJob.find(:all ,:conditions => ['newstype=? && job_start_date >=? && job_start_date <=?',newstype,@now_date, @enddate])
  
   # This part is check every 15 min to currunt date and time 
   # this part is work in Cron Job function (cpanel / advance / cron job)
   # cron job is automaticaly check every 15 min to currunt time
   # you also change time and also change cron job time (for Ex: here to set time is 20 min and cron job time set 15 min then time is not propper Email not Send)
  
   @newstemp =[]
   @emailp=[]
	
   # check_email_pref To Check to call updateA or updateO
   	
    if newstype == "updateA"
      check_email_pref = "attendee_update"
    elsif newstype == "updateO"
      check_email_pref = "org_update"
    end
 
    k=0
    i=0
    if @news.count >0
      @news.each do |nw|
              @user = EmailPreference.find(:all ,:conditions =>[check_email_pref,'1'])	# Condition Check
              if @user && @user !=nil && @user !=''
                if @user.count >0	# count how many user to send mail in User Table
                  @user.each do |ep|
                        @emailp[i] = User.find(:all, :conditions => ['id in(?)', ep[:user_id]])
                        UserMailer.newsletter_job(nw[:newsletter_id],ep[:user_id]).deliver	# mailler function to call
                        nw[:check_send] = 1	# to send mail To value is 0 to update 1
                        nw.save
                        i = i + 1 
                  end
              end
            end
          
        k=k+1
      end
    end
    return @emailp
  end
  
  
  
end