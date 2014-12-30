class SearchController < ApplicationController
   
   def index
        @site = SiteSetting.find(:first)
        
        @geoip ||= GeoIP.new(Rails.root.join("lib/GeoIP.dat"))  #@geoip.country(request.remote_ip) 
        ip = request.remote_ip
        
          result = GeoIP.new(Rails.root.join("lib/GeoLiteCity.dat")).city(ip)
          if ip=='127.0.0.1' || @site[:site_mode]==0
            @city = ''
          else  
            @city=result.city_name
          end
          
        if params[:search_city] && params[:search_city]!=''
            @city=params[:search_city]
            
        elsif params[:search_city]==''
           @city = ''          
             
        else
          params[:search_city] = @city
        end  
         
         @meta_title = @city+ (I18n.t 'meta_title.event_view')
         #@event_s = Event.where("active = ? AND cancel=? AND keep_private=0 AND (vanue_name like ? or street_address like ?) ", 1, 0, "%#{params[:search_city]}%", "%#{params[:search_city]}%").paginate(:page => params[:page], :per_page => 5).order('id DESC')
         order_by = 'order by id DESC'
         per_page = 6
         query = ' active = 1 AND cancel=0 AND keep_private=0 AND event_end_date_time >= "'+Time.now.strftime('%Y-%m-%d %H:%M:%S').to_s+'" AND (vanue_name like "%'+@city+'%" or street_address like "%'+@city+'%")'

        if params[:search_category] && params[:search_category]!=''
             @search_category = params[:search_category]
            @meta_title = 'Search Events'
            #@event_s = Event.where("active = ? AND cancel=?  AND keep_private=0 AND DATE(event_start_date_time) = ? ", 1, 0, Date.today).paginate(:page => params[:page], :per_page => 5).order('id DESC')
            query = query + ' AND (category in (select id from categories where category_name like "%'+params[:search_category]+'") or subcategory in (select id from categories where category_name like "%'+params[:search_category]+'%") or ( event_title like "%'+params[:search_category]+'%" ))'
         
        elsif params[:type]=='today'
            @meta_title = (I18n.t 'meta_title.today_events')
            query = query + ' AND DATE(event_start_date_time) <= "'+ Date.today.strftime('%Y-%m-%d').to_s+'" AND DATE(event_end_date_time) >= "'+ Date.today.strftime('%Y-%m-%d').to_s+'"'

             
        elsif params[:type]=='tomorrow'
            @meta_title = (I18n.t 'meta_title.tomorrow_events')
            query = query + ' AND DATE(event_start_date_time) <= "'+ (Date.today + 1.days).strftime('%Y-%m-%d').to_s+'" AND DATE(event_end_date_time) >= "'+ Date.today.strftime('%Y-%m-%d').to_s+'"'

            
        elsif params[:type]=='this_week'
            @meta_title = (I18n.t 'meta_title.this_week_events')
            time = Time.new
            day = time.wday
            eday = 6 - day
            query = query + ' AND DATE(event_start_date_time) <= "'+ Date.today.strftime('%Y-%m-%d').to_s+'" AND (DATE(event_end_date_time) >= "'+(Date.today + eday.days).strftime('%Y-%m-%d').to_s+'" OR DATE(event_end_date_time) = "'+ Date.today.strftime('%Y-%m-%d').to_s+'")'
            
       elsif params[:type]=='weekend'
            @meta_title = (I18n.t 'meta_title.this_weekend_events')
            time = Time.new
            day = time.wday
            add_day = 6 - day
            last_day = add_day +1 

            query = query + ' AND ( ( DATE(event_start_date_time) <= "'+ (Date.today + add_day.days).strftime('%Y-%m-%d').to_s+'" AND  DATE(event_end_date_time) >= "'+ (Date.today + add_day.days).strftime('%Y-%m-%d').to_s+'")
            OR
                                   ( DATE(event_start_date_time) <= "'+ (Date.today + last_day.days).strftime('%Y-%m-%d').to_s+'" AND  DATE(event_end_date_time) >= "'+ (Date.today + last_day.days).strftime('%Y-%m-%d').to_s+'")
                                   )'
            
         elsif params[:type]=='next_week'
            @meta_title = (I18n.t 'meta_title.next_week_events')
            time = Time.new
            day = time.wday
           
            if day == 0
              add_day = day + 1  
              last_day = add_day + 6
            else
              add_day =  8 - day
              #add_day = day + temp_day  
              last_day = add_day + 6
            end
           
           # render :text => (Date.today + add_day.days).strftime('%Y-%m-%d').to_s+ "   "+ (Date.today + last_day.days).strftime('%Y-%m-%d').to_s and return
            
            query = query + ' AND ( ( DATE(event_start_date_time) <= "'+ (Date.today + add_day.days).strftime('%Y-%m-%d').to_s+'" AND  DATE(event_end_date_time) >= "'+ (Date.today + add_day.days).strftime('%Y-%m-%d').to_s+'")
            OR
                                   ( DATE(event_start_date_time) <= "'+ (Date.today + last_day.days).strftime('%Y-%m-%d').to_s+'" AND  DATE(event_end_date_time) >= "'+ (Date.today + last_day.days).strftime('%Y-%m-%d').to_s+'")
                                   )'
           
            
        elsif params[:type]=='month'
            @meta_title = (I18n.t 'meta_title.this_month_events')
            query = query + ' AND (MONTH(event_start_date_time) <= "'+Time.now.strftime('%m').to_s+'" OR MONTH(event_end_date_time) >= "'+Time.now.strftime('%m').to_s+'" )'
        
        elsif params[:type]=='all_price'
            @meta_title = (I18n.t 'meta_title.all_price')
        
        elsif params[:type]=='free'
            @meta_title = (I18n.t 'meta_title.free_events')
            query = query + ' AND id in (select event_id from tickets where free=1)'
            
        elsif params[:type]=='not_free'
            @meta_title = (I18n.t 'meta_title.paid_donation_events')
            query = query + ' AND id in (select event_id from tickets where paid=1 or donation=1)'    
            
        else 
            @meta_title = (I18n.t 'meta_title.discover_events')
           # @event_s = Event.where("active = ? AND cancel=? AND keep_private=0  AND event_end_date_time >= ?  ", 1, 0, DateTime.now).paginate(:page => params[:page], :per_page => 5).order('id DESC')
           query = query + ' AND event_end_date_time >= "'+Time.now.strftime('%Y-%m-%d %H:%I:%S').to_s+'"'
        end
        @event_s = Event.find_by_sql('select * from events where '+query+' '+order_by).paginate(:page => params[:page], :per_page => per_page)
        
        #render :text => 'select * from events where '+query+' '+order_by
        render :layout => 'home', :template => 'search/index'
    end
    
    
    def category
        query = "active = 1 AND cancel=0 AND keep_private=0 AND event_end_date_time >= ?"
        if params[:search_city] && params[:search_city]!=''
            @city = params[:search_city].downcase
            query = query + " AND (vanue_name like '%"+@city+"%' or street_address like '%"+@city+"%')"
        end
        
         if params[:search_category] && params[:search_category]!=''
            @meta_title = 'Search Events'
            #@event_s = Event.where("active = ? AND cancel=?  AND keep_private=0 AND DATE(event_start_date_time) = ? ", 1, 0, Date.today).paginate(:page => params[:page], :per_page => 5).order('id DESC')
            query = query + ' AND (category in (select id from categories where category_name like "%'+params[:search_category]+'") or subcategory in (select id from categories where category_name like "%'+params[:search_category]+'%"))'
         end   
            
        if params[:id]
            @catname = Category.find(params[:id])
            @meta_title = @catname[:category_name]+' Events'
            @event_s = Event.where(query+" AND category = ? ", Time.now.strftime('%Y-%m-%d %H:%M:%S'), @catname[:id]).paginate(:page => params[:page], :per_page => 6).order('id DESC')
        
        else 
            @meta_title = (I18n.t 'meta_title.discover_events')
            @event_s = Event.where(query, Time.now.strftime('%Y-%m-%d %H:%M:%S')).paginate(:page => params[:page], :per_page => 6).order('id DESC')
        end
        @site = SiteSetting.find(:first)
        render :layout => 'home', :template => 'search/index'
        #render :text => query
    end
end