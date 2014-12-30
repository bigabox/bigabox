var email_reg_exp= /^[a-zA-Z0-9]+[a-zA-Z0-9_.-]+[a-zA-Z0-9_-]+@[a-zA-Z0-9]+[a-zA-Z0-9.-]+[a-zA-Z0-9]+.[a-z]{2,4}$/;
var LetNumSpec=/^[0-9a-zA-Z_-]+$/;
var number=/^[0-9]+$/;
var amount=/^[0-9.]+$/;
var alpha=/^[a-zA-Z]+$/;
var alphanum=/^[a-zA-Z0-9]+$/;
var alphaspace=/^[a-z A-Z]+$/;
var profilename=/^[a-z0-9]+$/;
var LetNumSpaceSpec=/^[0-9a-z A-Z_-]+$/;
var content_email=/^\b\w+\@\w+[\.\w+]+\b$/;

var url_reg_exp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
var fbusername = /^[a-zA-Z0-9.]+$/;
var twusername = /^[a-zA-Z0-9_]+$/;

//var passwordexp = ((?=.*\d)(?=.*[A-Z])(?=.*\W).{8,8});
var passwordexp = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z](?=.*\W).{8,25}$/;

	function validateRequired(value,errdivid,fieldname){
		var a = value;
		var errdiv = $('#'+errdivid);
		
		if(a=='')
		{
			errdiv.text(fieldname+validat_js_field_req);
			errdiv.addClass("error1");
			
			return false;
			
		}
	}
	
	function validateZipcode(ele,errdivid)
	{
		
		//testing regular expression
		var a = ele.value;
		var filter = number;
		var errdiv = $('#'+errdivid);
		
		if(a.length < 4 )
		{		
			errdiv.text(validat_js_enter_valid_zip);
			errdiv.addClass("error1");
			
			return false;
		} 
		
		else {
			
			//if it's valid number
			if(filter.test(a)){
				errdiv.text(validat_js_valid_zip);
				errdiv.removeClass("error1");	
				errdiv.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				errdiv.removeClass("success");
				errdiv.text(validat_js_enter_valid_zip);
				errdiv.addClass("error1");
				ele.value='';
				return false;
			}
		}
	}
	
	
	
	
	
	function validateMobileno(ele,errdivid)
	{
		
		//testing regular expression
		var a = ele.value;
		var filter = number;
		var errdiv = $('#'+errdivid);
		
	 if(a!='')
	 {	
		if(a.length <= 9 )
		{		
			errdiv.removeClass("success");
			errdiv.text(validat_js_enter_valid_10_digit_num);
			errdiv.addClass("error1");
			ele.value='';
			return false;
		} 
		
		else if(a.length > 10 )
		{		
			errdiv.removeClass("success");
			errdiv.text(validat_js_enter_valid_10_digit_num);
			errdiv.addClass("error1");
			ele.value='';
			return false;
		} 
		
		else {
			
			//if it's valid number
			if(filter.test(a)){
				errdiv.text(validat_js_valid_number);
				errdiv.removeClass("error1");	
				errdiv.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				errdiv.removeClass("success");
				errdiv.text(validat_js_enter_valid_10_digit_num);
				errdiv.addClass("error1");
				ele.value='';
				return false;
			}
		}
		
		
		} else {  return true; }	
	}
	
	
	
	
	function validatePhoneno(ele,errdivid)
	{
		
		//testing regular expression
		var a = ele.value;
		var filter = number;
		var errdiv = $('#'+errdivid);
			
		 if(a!='' && a.length > 1 )
		 {
				//if it's valid number
				if(filter.test(a))
				{
					
					if(a.length > 15 )
					{		
						errdiv.removeClass("success");
						errdiv.text(validat_js_enter_valid_less_15_digit);
						errdiv.addClass("error1");
						ele.value='';
						return false;
					}
					else { 
						errdiv.text(validat_js_valid_number);
						errdiv.removeClass("error1");	
						errdiv.addClass("success");
						return true;
					 }
			   }
			   //if it's NOT valid
				else{
					errdiv.removeClass("success");
					errdiv.text(validat_js_enter_valid_less_15_digit);
					errdiv.addClass("error1");
					ele.value='';
					return false;
				}
		   
		
		}
		
		else
		{
			return true;	
		}
			
		
	}
	
	

	