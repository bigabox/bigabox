$(document).ready(function(){	
	
	
	var email_reg_exp= /^[a-zA-Z0-9]+[a-zA-Z0-9_.-]+[a-zA-Z0-9_-]+@[a-zA-Z0-9]+[a-zA-Z0-9.-]+[a-zA-Z0-9]+.[a-z]{2,4}$/;
	var LetNumSpec=/^[0-9a-zA-Z_-]+$/;
	var number=/^[0-9]+$/;
	var amount=/^[0-9.]+$/;
	var alpha=/^[a-zA-Z]+$/;
	var alphaspace=/^[a-z A-Z]+$/;
	var alphanum=/^[a-zA-Z0-9]+$/;
	var profilename=/^[a-z0-9]+$/;
	var LetNumSpaceSpec=/^[0-9a-z A-Z_-]+$/;
	var content_email=/^\b\w+\@\w+[\.\w+]+\b$/;
	
	var custom_url = /^[a-zA-Z0-9_-]+$/;
	var url_reg_exp = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
	var fbusername = /^[a-zA-Z0-9.]+$/;
	var twusername = /^[a-zA-Z0-9_]+$/;
	
	//var passwordexp = ((?=.*\d)(?=.*[A-Z])(?=.*\W).{8,8});
	var passwordexp = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z](?=.*\W).{8,25}$/;
	//validate_request();
	//validate_socialsignup();
	
	/* validate_signup();
	 validate_login();
	 validate_forget();
	 validate_reset();
	  validate_edit_account();
	   validate_change_passsword();
	   validate_offer_task();
	   validate_askquestion();
	   
	     validate_postmessage();*/
	   
	
	//global vars
	
	
	
$('#socialsignupbtn').click( function() {		
		
		 validate_socialsignup();
 });
		
	
	
$('#sign_up').click( function() {		
		
		// validate_signup();
		validate_login('sign');	
 });

$('#loginbtn').click( function() {		
		
		 validate_login('login');	
 });
$('#forgetbtn').click( function() {		
		
		 validate_forget();	
 });	
	
$('#resetbtn').click( function() {		
		
		 validate_reset();	
 });	

$('#loginbtn_multi').click( function() {		
		
		 validate_multi();	
 });	
		

$('#changepasswordbtn').click( function() {		
		
		 validate_change_passsword();	
 });	
	
	
$('#editbtn').click( function() {		
		
		 validate_edit_account();	
 });	
	

$('#create_event_submit').click( function() {		
		
		 validate_create_event();	
 });

$('.create_event_submit').unbind("click").click( function() {		
		
		
		 validate_create_event();	
 });
 
 $('.orgprofileForm').click( function() {		
		
		validate_orgprofileForm();	
 });
 
 $('#newcontactForm').click( function() {		
		
		 validate_newcontactForm();	
 });
 
 
 
function validate_socialsignup()
	{
	
		var form = $("#signupForm");
		
		var user_name = $("#user_name");
		var user_nameInfo = $("#user_nameInfo");
	
		var email = $("#email");
		var emailInfo = $("#emailInfo");
	
		
		var password = $("#password");
		var passwordInfo = $("#passwordInfo");
		
		
		//On blur
		user_name.blur(validateUserName);		
		email.blur(validateEmail);
		password.blur(validatePassword);
		
		
		//On key up
		//user_name.keyup(validateUserName);		
		//email.keyup(validateEmail);
		password.keyup(validatePassword);
		
		
		
		
		//On Submitting
		form.submit(function(){
			if(validateUserName() & validateEmail() & validatePassword())
				return true
			else
				return false;
		});
		
	
	
	
	
	//validation functions
	
	function checkAvailability()
	{	
		
		var email = $("#email");
		var emailInfo = $("#emailInfo");
	
           
                // show our holding text in the validation message space
                emailInfo.removeClass('error1');
				emailInfo.html('<img src="'+baseThemeUrl+'/images/ajax-loader.gif" height="16" width="16" /> checking availability...');
				
			
          var res = $.ajax({						
						type: 'POST',
                        url: baseUrl+'home/checkemailavailability',
                        data: 'email=' + email.val(),
                        dataType: 'json', 
						cache: false,
						async: false                     
                    }).responseText;
		  
	
				return res;	
              
        
	}
	
	
	function validateEmail()
	{
	
		//testing regular expression
		var a = $("#email").val();
		var filter = email_reg_exp;
		
		
		if(a=='')
		{
			email.addClass("error1");
			emailInfo.text("Sorry, you must specify an E-mail address");
			emailInfo.addClass("error1");
			
			return false;
			
		}
		
		
		//if it's valid
		else{
			
				//if it's valid email
				if(filter.test(a)){
			email.removeClass("error1");
			emailInfo.text("E-mail address is valid!");
			emailInfo.removeClass("error1");
			emailInfo.addClass("success");
			
			
			var chk=checkAvailability();
			
			var obj = jQuery.parseJSON(chk);

			if(obj.ok==true)
			{				
				
				email.removeClass("error1");
				emailInfo.text("E-mail address is available!");
				emailInfo.addClass("success");
				
				return true;
			}
			else
			{
				email.addClass("error1");
				emailInfo.text("E-mail address is not available!");
				emailInfo.addClass("error1");
				return false;
			}
			
			
		}
		
				//if it's NOT valid
			else{
					email.addClass("error1");
					emailInfo.text("Type a valid E-mail");
					emailInfo.addClass("error1");
					return false;
				}
		}
		
	}
	
	
	
	function validatePassword()
	{
		
		var a = $("#password");	
		
		var filter = passwordexp;
		
		if(a.val()==''){
			password.addClass("error1");
			passwordInfo.text("Password is required");
			passwordInfo.addClass("error1");
			return false;
		}
		else if(filter.test(a)){
			password.removeClass("error1");
			passwordInfo.text("Password is valid.");
			passwordInfo.removeClass("error1");
			passwordInfo.addClass("success");
			return true;
		}
		//if it's NOT valid
		else{
			password.addClass("error1");
			passwordInfo.text("Password should be 8-25 characters, containing at least one digit, one lower case, one upper case, one special character. ");
			passwordInfo.addClass("error1");
			return false;
		}
	}
	
	
	function checkUsernameAvailability()
	{	
		
		var user_name = $("#user_name");
		var user_nameInfo = $("#user_nameInfo");
	
           
              // show our holding text in the validation message space
             user_nameInfo.removeClass('error1');
			user_nameInfo.html('<img src="'+baseThemeUrl+'/images/ajax-loader.gif" height="16" width="16" /> checking availability...');

          var res = $.ajax({						
						type: 'POST',
                        url: baseUrl+'home/checkusernameavailability',
                        data: 'user_name=' + user_name.val(),
                        dataType: 'json', 
						cache: false,
						async: false                     
                    }).responseText;
		  
				return res;	
	}
	
	
	function validateUserName()
	{	
		
		var a = $("#user_name").val();
		var filter = profilename;
			
		if(user_name.val()=='')
		{
			user_name.addClass("error1");
			user_nameInfo.text("Please use at least 3 characters");
			user_nameInfo.addClass("error1");
			
			return false;
			
		}
		//if it's NOT valid
		else if(user_name.val().length < 3){
			user_name.addClass("error1");
			user_nameInfo.text("Please use at least 3 characters");
			user_nameInfo.addClass("error1");
			return false;
		}
		
		
		//if it's valid
		else{			
			//if it's valid number
			if(filter.test(a)){
				
				var chk=checkUsernameAvailability();			
				var obj = jQuery.parseJSON(chk);			
			
				
				if(obj.ok==true)
				{						
					user_name.removeClass("error1");
					//user_nameInfo.text("Username is available!");
					user_nameInfo.html("<br/>");
					user_nameInfo.removeClass("error1");
					user_nameInfo.addClass("success");					
					return true;
				}
				else
				{				
					user_name.removeClass("error1");
					user_nameInfo.text("Username is not available!");
					user_nameInfo.addClass("error1");
					return false;
				}			
				
			}
			//if it's NOT valid
			else{
				user_name.addClass("error1");
				user_nameInfo.text("Enter valid user name.");
				user_nameInfo.addClass("error1");
				return false;
			}
			
			
		}
	}
	
	
	

	
	
	}
	
	
	
	
	function validate_signup()
	{
	
	
		
		var form = $("#signupForm");
		
		var full_name = $("#full_name");
		var full_nameInfo = $("#full_nameInfo");
		var full_nameTR = $("#full_nameTR");
				
		var zip_code = $("#zip_code");
		var zip_codeInfo = $("#zip_codeInfo");
		var zip_codeTR = $("#zip_codeTR");
		
		var mobile_no = $("#mobile_no");
		var mobile_noInfo = $("#mobile_noInfo");		
		var mobile_noTR = $("#mobile_noTR");		
		
		var email = $("#email");
		var emailInfo = $("#emailInfo");
		var emailTR = $("#emailTR");
		
		var password = $("#password");
		var passwordInfo = $("#passwordInfo");
		var passwordTR = $("#passwordTR");
		
		
		//On click		
		email.focus(function() {  
			
			emailTR.addClass('field_main'); 
			zip_codeTR.removeClass('field_main');
			passwordTR.removeClass('field_main');
			full_nameTR.removeClass('field_main');
			mobile_noTR.removeClass('field_main'); 
		} );
		
		password.focus(function() {  
			passwordTR.addClass('field_main'); 
			zip_codeTR.removeClass('field_main');
			emailTR.removeClass('field_main');	
			full_nameTR.removeClass('field_main');
			mobile_noTR.removeClass('field_main');  
		} );
		
		mobile_no.focus(function() {  
			mobile_noTR.addClass('field_main'); 
			zip_codeTR.removeClass('field_main');
			emailTR.removeClass('field_main');
			passwordTR.removeClass('field_main');
			full_nameTR.removeClass('field_main');
 		} );
		
		
		zip_code.focus(function() {  
			zip_codeTR.addClass('field_main');  
			emailTR.removeClass('field_main');
			passwordTR.removeClass('field_main');
			full_nameTR.removeClass('field_main');
			mobile_noTR.removeClass('field_main'); 
		} );
		
		full_name.focus(function() {  
			full_nameTR.addClass('field_main'); 
			zip_codeTR.removeClass('field_main');
			emailTR.removeClass('field_main');
			passwordTR.removeClass('field_main');
			mobile_noTR.removeClass('field_main');  
	} );
		
		
		
		//On blur
		full_name.blur(validateFullName);		
		zip_code.blur(validateZipcode1);
		mobile_no.blur(validateMobile);
		email.blur(validateEmail);
		password.blur(validatePassword);
		
		
		//On key up
		full_name.keyup(validateFullName);		
		zip_code.keyup(validateZipcode1);
		mobile_no.keyup(validateMobile);
		//email.keyup(validateEmail);
		password.keyup(validatePassword);
		
		
		
		
		//On Submitting
		form.submit(function(){
			if(validateFullName() & validateEmail() & validatePassword() & validateZipcode() & validateMobile())
				return true
			else
				return false;
		});
		
	
	
	
	
	//validation functions
	
	
	
	
	
	function checkAvailability()
	{	
		
		var email = $("#email");
		var emailInfo = $("#emailInfo");
	
           
                // show our holding text in the validation message space
                emailInfo.removeClass('error1');
				emailInfo.html('<img src="'+baseThemeUrl+'/images/ajax-loader.gif" height="16" width="16" /> checking availability...');
				
			
          var res = $.ajax({						
						type: 'POST',
                        url: baseUrl+'home/checkemailavailability',
                        data: 'email=' + email.val(),
                        dataType: 'json', 
						cache: false,
						async: false                     
                    }).responseText;
		  
	
				return res;	
              
        
	}
	
	
	function validateEmail()
	{
	
		//testing regular expression
		var a = $("#email").val();
		var filter = email_reg_exp;
		//if it's valid email
		if(filter.test(a)){
			email.removeClass("error1");
			emailInfo.text("E-mail address is valid!");
			emailInfo.removeClass("error1");
			emailInfo.addClass("success");
			
			
			var chk=checkAvailability();
			
			var obj = jQuery.parseJSON(chk);

			if(obj.ok==true)
			{				
				
				email.removeClass("error1");
				emailInfo.text("E-mail address is available!");
				emailInfo.addClass("success");
				
				return true;
			}
			else
			{
				email.addClass("error1");
				emailInfo.text("E-mail address is not available!");
				emailInfo.addClass("error1");
				return false;
			}
			
			
		}
		
		//if it's NOT valid
		else{
			email.addClass("error1");
			emailInfo.text("Type a valid e-mail please :P");
			emailInfo.addClass("error1");
			return false;
		}
	}
	
	
	
	function validatePassword()
	{
		
		var a = $("#password");	

		//it's NOT valid
		if(password.val().length < 7){
			password.addClass("error1");
			passwordInfo.text("At least 8 characters is required");
			passwordInfo.addClass("error1");
			return false;
		}
		//it's valid
		else{			
			password.removeClass("error1");
			passwordInfo.text("Ey! Remember: your password");
			passwordInfo.removeClass("error1");
			passwordInfo.addClass("success");
			return true;
		}
	}
	
	
	function validateFullName()
	{	
		
		var a = $("#full_name").val();
		var filter = alphaspace;
			
		if(full_name.val()=='')
		{
			full_name.addClass("error1");
			full_nameInfo.text("Enter Full name!");
			full_nameInfo.addClass("error1");
			
			return false;
			
		}
		//if it's NOT valid
		else if(full_name.val().length < 4){
			full_name.addClass("error1");
			full_nameInfo.text("We want names with more than 4 letters!");
			full_nameInfo.addClass("error1");
			return false;
		}
		
		
		//if it's valid
		else{
			
			
			
			//if it's valid number
			if(filter.test(a)){
				full_name.removeClass("error1");
				full_nameInfo.text("Full name is valid");
				full_nameInfo.removeClass("error1");
				full_nameInfo.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				full_name.addClass("error1");
				full_nameInfo.text("Enter valid full name.");
				full_nameInfo.addClass("error1");
				return false;
			}
			
			
		}
	}
	
	
	
	function validateMobile()
	{
		
		//testing regular expression
		var a = $("#mobile_no").val();
		var filter = number;
		
		if(mobile_no.val()!='')
		{
		
		/*if(mobile_no.val()=='')
		{
			mobile_no.addClass("error1");
			mobile_noInfo.text("Enter valid 10 digit mobile number!");
			mobile_noInfo.addClass("error1");
			
			return false;
			
		}
	
		else*/ if(mobile_no.val().length <= 9 )
		{		
			mobile_no.addClass("error1");
			mobile_noInfo.text("Enter valid 10 digit mobile number!");
			mobile_noInfo.addClass("error1");
			return false;
		} 
		
		else if(mobile_no.val().length > 10 )
		{		
			mobile_no.addClass("error1");
			mobile_noInfo.text("Enter valid 10 digit mobile number!");
			mobile_noInfo.addClass("error1");
			return false;
		} 
		
		else {
			
			//if it's valid number
			if(filter.test(a)){
				mobile_no.removeClass("error1");
				mobile_noInfo.text("Valid mobile number.");
				mobile_noInfo.removeClass("error1");		
				mobile_noInfo.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				mobile_no.addClass("error1");
				mobile_noInfo.text("Enter valid 10 digit mobile number.");
				mobile_noInfo.addClass("error1");
				return false;
			}
		}
		
		
		} else {  return true; }	
	}
	
	
	function validateZipcode1()
	{
		
		//testing regular expression
		var a = $("#zip_code").val();
		var filter = alphanum;
		
		if(zip_code.val()=='')
		{
			zip_code.addClass("error1");
			zip_codeInfo.text("Enter valid postal code number!");
			zip_codeInfo.addClass("error1");
			
			return false;
			
		}
	
		else if(zip_code.val().length < 4 )
		{		
			zip_code.addClass("error1");
			zip_codeInfo.text("Enter valid postal code number!");
			zip_codeInfo.addClass("error1");
			return false;
		} 
		
		else {
			
			//if it's valid number
			if(filter.test(a)){
				zip_code.removeClass("error1");
				zip_codeInfo.text("Valid postal code number.");
				zip_codeInfo.removeClass("error1");	
				zip_codeInfo.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				zip_code.addClass("error1");
				zip_codeInfo.text("Enter valid postal code number.");
				zip_codeInfo.addClass("error1");
				return false;
			}
		}
	}
	

	
	
	
	}
	
	
	function validate_login(type)
	{
	
	
		//alert('hi');
		if(type=='login'){
			var form = $("#loginForm");	
			
		
			var login_email = $("#user_email");
			var loginemailInfo = $("#useremailInfo");
			
			
			var login_password = $("#user_password");
			var loginPasswordInfo = $("#userPasswordInfo");
		}
		
		if(type=='sign'){
			var form = $("#signForm");	
			
		
			var login_email = $("#sign_user_email");
			var loginemailInfo = $("#signuseremailInfo");
			
			
			var login_password = $("#sign_user_password");
			var loginPasswordInfo = $("#signuserPasswordInfo");
		}
		
		//On click		
		login_email.focus(function() {  
			
		
			
		} );
		
		login_password.focus(function() {  
			
		} );
		
		
		
		
		//On blur
		
		login_email.blur(validateEmail);
		login_password.blur(validatePassword);
	
		login_password.keyup(validatePassword);
		
		
		//On Submitting
		form.submit(function(){
			if(validateEmail() & validatePassword()){
				
				return true;
			}	
			else{
				return false; }
		});
		
	
	
	
	
	
	
	//validation functions
	function validateEmail(){
		//testing regular expression
		var a = login_email.val();
		var filter = email_reg_exp;
		//if it's valid email
		if(filter.test(a)){
			loginemailInfo.text(validat_js_email_address_valid);
			loginemailInfo.removeClass("error1");
			loginemailInfo.addClass("success");
			return true;
		}
		//if it's NOT valid
		else{
			loginemailInfo.removeClass("success");
			loginemailInfo.text(validat_js_type_valid_email);
			loginemailInfo.addClass("error1");
			return false;
		}
	}
	
	function validatePassword(){
	//	var a = $("#login_password");
	
		
		var a = login_password;	
		
		var filter = passwordexp;
		
		if(a.val()==''){
			loginPasswordInfo.removeClass("success");
			loginPasswordInfo.text(validat_js_pwd_req);
			loginPasswordInfo.addClass("error1");
			return false;
		}
		else if(filter.test(a.val())){
			
			loginPasswordInfo.text(validat_js_pwd_valid);
			loginPasswordInfo.removeClass("error1");
			loginPasswordInfo.addClass("success");
			return true;
		}
		//if it's NOT valid
		else{
			loginPasswordInfo.removeClass("success");
			loginPasswordInfo.text(validat_js_pwd_one_lower_one_upper_one_special);
			loginPasswordInfo.addClass("error1");
			return false;
		}
		
	}
	
	
	
	
	}
	
	function validate_multi()
	{
	
	
		//alert('hi');
		if(type=='login'){
			var form = $("#loginForm");	
			
		
			var login_email = $("#user_email");
			var loginemailInfo = $("#useremailInfo");
			
		}
		
				
		//On click		
		login_email.focus(function() {  
			
		
			
		} );
		
		
		//On blur
		
		login_email.blur(validateEmail);
		
		//On Submitting
		form.submit(function(){
			if(validateEmail() & validatePassword()){
				
				return true;
			}	
			else{
				return false; }
		});
		
	
	//validation functions
	function validateEmail(){
		//testing regular expression
		var a = login_email.val();
		var filter = email_reg_exp;
		//if it's valid email
		if(filter.test(a)){
			loginemailInfo.text(validat_js_email_address_valid);
			loginemailInfo.removeClass("error1");
			loginemailInfo.addClass("success");
			return true;
		}
		//if it's NOT valid
		else{
			loginemailInfo.removeClass("success");
			loginemailInfo.text(validat_js_type_valid_email);
			loginemailInfo.addClass("error1");
			return false;
		}
	}
	
}
	
	
	function validate_forget()
	{
	
	
		
		var form = $("#forgetForm");	
		
	
		var forget_email = $("#user_email");
		var forgetEmailInfo = $("#useremailInfo");
	
		
	
		
		//On click		
		forget_email.focus(function() {  
			
			
		
		} );
		
		
		
		//On blur
		
		forget_email.blur(validateEmail);
		
	
	
		forget_email.keyup(validateEmail);
		
		
		//On Submitting
		form.submit(function(){
			if(validateEmail())
				return true
			else
				return false;
		});
		
	
	
	
	
	
	
	//validation functions
	function validateEmail(){
		//testing regular expression
		var a = $("#user_email").val();
		var filter = email_reg_exp;
		//if it's valid email
		if(filter.test(a)){
				
			forgetEmailInfo.text(validat_js_email_address_valid);
			forgetEmailInfo.removeClass("error1");
			forgetEmailInfo.addClass("success");
			return true;
		}
		//if it's NOT valid
		else{
			
			forgetEmailInfo.text(validat_js_type_valid_email);
			forgetEmailInfo.addClass("error1");
			return false;
		}
	}
	

	
	}
	
	
	
	function validate_reset()
	{
		
		
		
		
		var form = $("#resetForm");	
		
	
		var new_password = $("#password");
		var newpasswordInfo = $("#passInfo");
	
		
		
		var confirm_password = $("#cpassword");
		var confirmpasswordInfo = $("#cpassInfo");
		
		
	
		
		//On click		
		
	
		
		new_password.focus(function() {  
		
		} );
		
		confirm_password.focus(function() {  
			
		} );
		
		
		
		//On blur
		
		new_password.blur(validatePass1);
		confirm_password.blur(validatePass2);
		
	
	
		new_password.keyup(validatePass1);
		confirm_password.keyup(validatePass2);
		
		
		//On Submitting
		form.submit(function(){
			if(validatePass1() & validatePass2())
				return true
			else
				return false;
		});
		
	

		
		function validatePass1(){
		var a = $("#password");
		var b = $("#cpassword");

		var filter = passwordexp;
		
		if(new_password.val()==''){
			newpasswordInfo.removeClass("success");
			newpasswordInfo.text(validat_js_pwd_req);
			newpasswordInfo.addClass("error1");
			return false;
		}
		else if(filter.test(new_password.val())){
			newpasswordInfo.text(validat_js_pwd_valid);
			newpasswordInfo.removeClass("error1");
			newpasswordInfo.addClass("success");
			
			validatePass2();
			
			return true;
		}
		//if it's NOT valid
		else{
			newpasswordInfo.removeClass("success");
			newpasswordInfo.text(validat_js_pwd_one_lower_one_upper_one_special);
			newpasswordInfo.addClass("error1");
			return false;
		}
		
		
	}
	function validatePass2(){
		var a = $("#password");
		var b = $("#cpassword");
		var filter = passwordexp;
		
		if(confirm_password.val()==''){
			confirmpasswordInfo.removeClass("success");
			confirmpasswordInfo.text(validat_js_pwd_req);
			confirmpasswordInfo.addClass("error1");
			return false;
		}
		else if(filter.test(confirm_password.val())){
			
			if( new_password.val() != confirm_password.val() ){
				confirmpasswordInfo.removeClass("success");
				confirmpasswordInfo.text(validat_js_pwd_not_match);
				confirmpasswordInfo.addClass("error1");
				return false;
			}
			//are valid
			else{
				
				confirmpasswordInfo.text(validat_js_confirm_pwd_match);
				confirmpasswordInfo.removeClass("error1");
				confirmpasswordInfo.addClass("success");
				return true;
			}
		}
		//if it's NOT valid
		else{
			confirmpasswordInfo.removeClass("success");
			confirmpasswordInfo.text(validat_js_pwd_one_lower_one_upper_one_special);
			confirmpasswordInfo.addClass("error1");
			return false;
		}
		
		
		
	
		
	}
	
	
		
	}
	
	
	function validate_change_passsword()
	{
		
		
		
		
		var form = $("#changepasswordForm");	
		
	
		//var old_password = $("#old_password");
		//var oldpasswordInfo = $("#oldpasswordInfo");
		
		
		var new_password = $("#new_password");
		var newpasswordInfo = $("#newpasswordInfo");
	
		
		
		var confirm_password = $("#confirm_password");
		var confirmpasswordInfo = $("#confirmpasswordInfo");
		
		
	
		
		//On click		
		
		//old_password.focus(function() {  
		
		//} );
		
		new_password.focus(function() {  
		
		} );
		
		confirm_password.focus(function() {  
			
		} );
		
		
		
		//On blur
		//old_password.blur(validatePass3);
		new_password.blur(validatePass1);
		confirm_password.blur(validatePass2);
		
	
		//old_password.keyup(validatePass3);
		new_password.keyup(validatePass1);
		confirm_password.keyup(validatePass2);
		
		
		//On Submitting
		form.submit(function(){
			if(validatePass1() & validatePass2())
				return true
			else
				return false;
		});
		
	
	
	
/*	function validatePass3(){
		var a = $("#old_password");
		

		//it's NOT valid
		if(old_password.val().length <7){
			old_password.addClass("error1");
			oldpasswordInfo.text("At least 8 characters is required.");
			oldpasswordInfo.addClass("error1");
			return false;
		}
		//it's valid
		else{			
			old_password.removeClass("error1");
			oldpasswordInfo.text("Old Password is valid.");
			oldpasswordInfo.removeClass("error1");
			oldpasswordInfo.addClass("success");
			validatePass1();
			return true;
		}
	}*/
	
	
	
		
		function validatePass1(){
		var a = $("#new_password");
		var b = $("#confirm_password");

		var filter = passwordexp;
		
		if(new_password.val()==''){
			newpasswordInfo.removeClass("success");
			newpasswordInfo.text("Password is required");
			newpasswordInfo.addClass("error1");
			return false;
		}
		else if(filter.test(new_password.val())){
			newpasswordInfo.text("Password is valid.");
			newpasswordInfo.removeClass("error1");
			newpasswordInfo.addClass("success");
			
			validatePass2();
			
			return true;
		}
		//if it's NOT valid
		else{
			newpasswordInfo.removeClass("success");
			newpasswordInfo.text("Password should be 8-25 characters, containing at least one digit, one lower case, one upper case, one special character. ");
			newpasswordInfo.addClass("error1");
			return false;
		}
		
	}
	function validatePass2(){
		var a = $("#new_password");
		var b = $("#confirm_password");
		//are NOT valid
		
		var filter = passwordexp;
		
		if(confirm_password.val()==''){
			confirmpasswordInfo.removeClass("success");
			confirmpasswordInfo.text("Password is required");
			confirmpasswordInfo.addClass("error1");
			return false;
		}
		else if(filter.test(confirm_password.val())){
			if( new_password.val() != confirm_password.val() ){
					confirmpasswordInfo.removeClass("success");
					confirm_password.addClass("error1");
					confirmpasswordInfo.text("Passwords doesn't match!");
					confirmpasswordInfo.addClass("error1");
					return false;
				}
				//are valid
				else{
					confirm_password.removeClass("error1");
					confirmpasswordInfo.text("Confirm password is match.");
					confirmpasswordInfo.removeClass("error1");
					confirmpasswordInfo.addClass("success");
					return true;
				}
			
			return true;
		}
		//if it's NOT valid
		else{
			confirmpasswordInfo.removeClass("success");
			confirmpasswordInfo.text("Password should be 8-25 characters, containing at least one digit, one lower case, one upper case, one special character. ");
			confirmpasswordInfo.addClass("error1");
			return false;
		}
		
		
		
	}
	
	
		
	}
	
	
	
	function validate_edit_account()
	{
	
	
		
		var form = $("#editForm");
		
		var user_name = $("#user_name");
		var user_nameInfo = $("#user_nameInfo");
		
		var first_name = $("#first_name");
		var first_nameInfo = $("#first_nameInfo");
		
		
		var last_name = $("#last_name");
		var last_nameInfo = $("#last_nameInfo");
	
		var email = $("#email");
		var emailInfo = $("#emailInfo");
		
	
		
		//On click		
		email.focus(function() {  
		
		} );
		
		last_name.focus(function() {  
		
		} );
		
		first_name.focus(function() {  
			
		} );
		
		user_name.focus(function() {  
		
 		} );
		
		
	
		
		
		
		
		//On blur
		first_name.blur(validateFirstName);		
		last_name.blur(validateLastName);		
		user_name.blur(validateUserName);
		email.blur(validateEmail);
		
		
		
		//On key up
		first_name.keyup(validateFirstName);		
		last_name.keyup(validateLastName);		
		//user_name.keyup(validateUserName);
		//email.keyup(validateEmail);
	
		
		
		
		
		//On Submitting
		form.submit(function(){
			if(validateFirstName() & validateLastName()  & validateEmail() & validateUserName())
				return true
			else
				return false;
		});
		
	
	
	
	
	//validation functions
	
	
	function checkAvailability()
	{	
		
		var email = $("#email");
		var emailInfo = $("#emailInfo");
	
           
                // show our holding text in the validation message space
                emailInfo.removeClass('error1');
				emailInfo.html('<img src="'+baseThemeUrl+'/images/ajax-loader.gif" height="16" width="16" /> checking availability...');
				
			
          var res = $.ajax({						
						type: 'POST',
                        url: baseUrl+'home/checkemailavailability',
                        data: 'email=' + email.val(),
                        dataType: 'json', 
						cache: false,
						async: false                     
                    }).responseText;
		  
	
				return res;	
              
        
	}
	
	
	function validateEmail()
	{
	
		//testing regular expression
		var a = $("#email").val();
		var filter = email_reg_exp;
		
		
		if(a=='')
		{
			email.addClass("error1");
			emailInfo.text("Sorry, you must specify an E-mail address");
			emailInfo.addClass("error1");
			
			return false;
			
		}
		
		
		//if it's valid
		else{
			
				//if it's valid email
				if(filter.test(a)){
			email.removeClass("error1");
			//emailInfo.text("E-mail address is valid!");
			emailInfo.html("<br/>");
			emailInfo.removeClass("error1");
			emailInfo.addClass("success");
			
			
			var chk=checkAvailability();
			
			var obj = jQuery.parseJSON(chk);

			if(obj.ok==true)
			{				
				
				email.removeClass("error1");
				//emailInfo.text("E-mail address is available!");
				emailInfo.html("<br/>");
				emailInfo.addClass("success");
				
				return true;
			}
			else
			{
				email.addClass("error1");
				emailInfo.text("E-mail address is not available!");
				emailInfo.addClass("error1");
				return false;
			}
			
			
		}
		
				//if it's NOT valid
			else{
					email.addClass("error1");
					emailInfo.text("Type a valid E-mail");
					emailInfo.addClass("error1");
					return false;
				}
		}
		
	}
	
	
	
	
	
	function validateFirstName()
	{	
		
		var a = $("#first_name").val();
		var filter = alpha;
			
		if(first_name.val()=='')
		{
			first_name.addClass("error1");
			first_nameInfo.text("Enter First name!");
			first_nameInfo.addClass("error1");
			
			return false;
			
		}
		//if it's NOT valid
		else if(first_name.val().length < 4){
			first_name.addClass("error1");
			first_nameInfo.text("We want names with more than 4 letters!");
			first_nameInfo.addClass("error1");
			return false;
		}
		
		
		//if it's valid
		else{
			
			
			
			//if it's valid number
			if(filter.test(a)){
				first_name.removeClass("error1");
				first_nameInfo.text("First name is valid");
				first_nameInfo.removeClass("error1");
				first_nameInfo.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				first_name.addClass("error1");
				first_nameInfo.text("Enter valid first name.");
				first_nameInfo.addClass("error1");
				return false;
			}
			
			
		}
	}
	
	
	
	function validateLastName()
	{	
		
		var a = $("#last_name").val();
		var filter = alpha;
			
		if(last_name.val()=='')
		{
			last_name.addClass("error1");
			last_nameInfo.text("Enter Last name!");
			last_nameInfo.addClass("error1");
			
			return false;
			
		}
		//if it's NOT valid
		else if(last_name.val().length < 4){
			last_name.addClass("error1");
			last_nameInfo.text("We want names with more than 4 letters!");
			last_nameInfo.addClass("error1");
			return false;
		}
		
		
		//if it's valid
		else{
			
			
			
			//if it's valid number
			if(filter.test(a)){
				last_name.removeClass("error1");
				last_nameInfo.text("Last name is valid");
				last_nameInfo.removeClass("error1");
				last_nameInfo.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				last_name.addClass("error1");
				last_nameInfo.text("Enter valid Last name.");
				last_nameInfo.addClass("error1");
				return false;
			}
			
			
		}
	}
	
	
	
	function checkUsernameAvailability()
	{	
		
		var user_name = $("#user_name");
		var user_nameInfo = $("#user_nameInfo");
	
           
              // show our holding text in the validation message space
             user_nameInfo.removeClass('error1');
			user_nameInfo.html('<img src="'+baseThemeUrl+'/images/ajax-loader.gif" height="16" width="16" /> checking availability...');

          var res = $.ajax({						
						type: 'POST',
                        url: baseUrl+'home/checkusernameavailability',
                        data: 'user_name=' + user_name.val(),
                        dataType: 'json', 
						cache: false,
						async: false                     
                    }).responseText;
		  
				return res;	
	}
	
	
	function validateUserName()
	{	
		
		var a = $("#user_name").val();
		var filter = profilename;
			
		if(user_name.val()=='')
		{
			user_name.addClass("error1");
			user_nameInfo.text("Please use at least 3 characters");
			user_nameInfo.addClass("error1");
			
			return false;
			
		}
		//if it's NOT valid
		else if(user_name.val().length < 3){
			user_name.addClass("error1");
			user_nameInfo.text("Please use at least 3 characters");
			user_nameInfo.addClass("error1");
			return false;
		}
		
		
		//if it's valid
		else{			
			//if it's valid number
			if(filter.test(a)){
				
				var chk=checkUsernameAvailability();			
				var obj = jQuery.parseJSON(chk);			
			
				
				if(obj.ok==true)
				{						
					user_name.removeClass("error1");
					//user_nameInfo.text("Username is available!");
					user_nameInfo.html("<br/>");
					user_nameInfo.removeClass("error1");
					user_nameInfo.addClass("success");					
					return true;
				}
				else
				{				
					user_name.removeClass("error1");
					user_nameInfo.text("Username is not available!");
					user_nameInfo.addClass("error1");
					return false;
				}			
				
			}
			//if it's NOT valid
			else{
				user_name.addClass("error1");
				user_nameInfo.text("Enter valid user name.");
				user_nameInfo.addClass("error1");
				return false;
			}
			
			
		}
	}
	
	
	

	
	}

	
	function validateMobile()
	{
		
		//testing regular expression
		var a = $("#mobile_no").val();
		var filter = number;
		
		if(mobile_no.val()!='')
		{
		if(mobile_no.val()=='')
		{
			mobile_no.addClass("error1");
			mobile_noInfo.text("Enter valid 10 digit mobile number!");
			mobile_noInfo.addClass("error1");
			
			return false;
			
		}
	
		else if(mobile_no.val().length <= 9 )
		{		
			mobile_no.addClass("error1");
			mobile_noInfo.text("Enter valid 10 digit mobile number!");
			mobile_noInfo.addClass("error1");
			return false;
		} 
		
		else if(mobile_no.val().length > 10 )
		{		
			mobile_no.addClass("error1");
			mobile_noInfo.text("Enter valid 10 digit mobile number!");
			mobile_noInfo.addClass("error1");
			return false;
		} 
		
		else {
			
			//if it's valid number
			if(filter.test(a)){
				mobile_no.removeClass("error1");
				mobile_noInfo.text("Valid mobile number.");
				mobile_noInfo.removeClass("error1");		
				mobile_noInfo.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				mobile_no.addClass("error1");
				mobile_noInfo.text("Enter valid 10 digit mobile number.");
				mobile_noInfo.addClass("error1");
				return false;
			}
		}
		
		} else { return true; }
	}
	
	function validatePhone()
	{
		
		//testing regular expression
		var a = $("#phone_no").val();
		var filter = number;
		
		
	
		
		
		
	 if(phone_no.val().length > 1 )
	 {
			//if it's valid number
			if(filter.test(a))
			{
				
				
				
				 if(phone_no.val().length > 15 )
				{		
					phone_no.addClass("error1");
					phone_noInfo.text("Enter valid and less than 15 digit phone number!");
					phone_noInfo.addClass("error1");
					return false;
				} 
				
				
				 else { phone_no.removeClass("error1");
						phone_noInfo.text("Valid phone number.");
						phone_noInfo.removeClass("error1");		
						phone_noInfo.addClass("success");
						return true;
						
				 }
		
		   }
		   //if it's NOT valid
			else{
				phone_no.addClass("error1");
				phone_noInfo.text("Enter valid phone number.");
				phone_noInfo.addClass("error1");
				return false;
			}
		   
		
		}
		
		else
		{
			return true;	
		}
			
		
	}
	
	
	function validateZipcode1()
	{
		
		//testing regular expression
		var a = $("#zip_code").val();
		var filter = alphanum;
		
		if(zip_code.val()=='')
		{
			zip_code.addClass("error1");
			zip_codeInfo.text("Enter valid postal code number!");
			zip_codeInfo.addClass("error1");
			
			return false;
			
		}
	
		else if(zip_code.val().length < 4 )
		{		
			zip_code.addClass("error1");
			zip_codeInfo.text("Enter valid postal code number!");
			zip_codeInfo.addClass("error1");
			return false;
		} 
		
		else {
			
			//if it's valid number
			if(filter.test(a)){
				zip_code.removeClass("error1");
				zip_codeInfo.text("Valid postal code number.");
				zip_codeInfo.removeClass("error1");	
				zip_codeInfo.addClass("success");
				return true;
			}
			//if it's NOT valid
			else{
				zip_code.addClass("error1");
				zip_codeInfo.text("Enter valid postal code number.");
				zip_codeInfo.addClass("error1");
				return false;
			}
		}
	}
	
	function validate_create_event(){
		
		
		var form = $("#create_event_form");	
		
	
		var event_title = $("#event_event_title");
		var eventtitleInfo = $("#eventtitleInfo");
		
		var online_event_option = $("#event_online_event_option").val();
		var vanue_name = $("#event_vanue_name");
		var vanuenameInfo = $("#vanuenameInfo");
		
		var street_address = $("#event_street_address1");
		var streetaddressInfo = $("#streetaddressInfo");
		
		var event_start_date_time = $("#event_event_start_date_time");
		var eventstartdatetimeInfo = $("#eventstartdatetimeInfo");
	
		var event_end_date_time = $("#event_event_end_date_time");
		var eventenddatetimeInfo = $("#eventenddatetimeInfo");
		
		var event_logo = $("#event_event_logo");
		var eventlogoInfo = $("#err1");
	
		var event_detail = $("#evet_event_detail");
		var eventdetailInfo = $("#eventdetailInfo");
	
		var event_event_url_link = $("#event_event_url_link");
		var eventurllinkInfo = $("#eventurllinkInfo");
		
		var organizererrorInfo = $("#organizererrorInfo");
		var event_organizer_host = $("#event_organizer_host");
		var org_event_id = $("#org_event_id");
		
		var event_facebook_link = $("#event_facebook_link");
		var event_facebook_link_err = $("#event_facebook_link_err");
		
		var event_twitter_link = $("#event_twitter_link");
		var event_twitter_link_err = $("#event_twitter_link_err");
		
		var ticket_req_fields = $('#ticket_req_fields');
		var tickets_div = $("#ticket_error");
		var submit_type = $('#submit_type');
		
		//set all errors null 
		eventtitleInfo.text("");
		vanuenameInfo.text("");
		streetaddressInfo.text("");
		eventstartdatetimeInfo.text("");
		eventenddatetimeInfo.text("");
		eventdetailInfo.text("");
		eventurllinkInfo.text("");
		organizererrorInfo.text("");
		ticket_req_fields.text("");
		event_facebook_link_err.text("");
		event_twitter_link_err.text("");
		tickets_div.text("");
		//On Submitting
		form.submit(function(){
			
			if(event_title.val()==''){
				event_title.focus();
				eventtitleInfo.text(validat_js_event_title_req);
				eventtitleInfo.addClass("error1");
				
				$('html, body').animate({
                    scrollTop: event_title.offset().top
                }, 200);
	         	
				return false;
			}
			
			
			if(online_event_option=='0' || online_event_option==''){
				if(vanue_name.val()==''){
					vanue_name.focus();
					vanuenameInfo.text(validat_js_venue_name_req);
					vanuenameInfo.addClass("error1");
					
					$('html, body').animate({
                    	scrollTop: vanue_name.offset().top
                     }, 200);
	         	
					
					return false;
				}
				if(street_address.val()==''){
					street_address.focus();
					streetaddressInfo.text(validat_js_street_add_req);
					streetaddressInfo.addClass("error1");
					$('html, body').animate({
                	    scrollTop: street_address.offset().top
                     }, 200);
	         	
					
					return false;
				}
			}
			
			
			if(event_start_date_time.val()==''){
				
				event_start_date_time.focus();
				eventstartdatetimeInfo.text(validat_js_event_start_date_req);
				eventstartdatetimeInfo.addClass("error1");
				
				$('html, body').animate({
                    scrollTop: event_start_date_time.offset().top
                }, 200);
	         	
				
				return false;
			}
			
			if(event_end_date_time.val()==''){
				event_end_date_time.focus();
				eventenddatetimeInfo.text(validat_js_event_end_date_req);
				eventenddatetimeInfo.addClass("error1");
				
				$('html, body').animate({
                    scrollTop: event_end_date_time.offset().top
                }, 200);
	         	
				
				return false;
			}
			
			//var strt_date = new Date(new Date(event_end_date_time.val()).getTime() + 60 * 60 * 3 * 1000)).toString('yyyy-MM-dd hh:mm');
			//alert(event_end_date_time.val());
			//alert(new Date(event_end_date_time.val()));
			//alert(new Date(new Date(event_end_date_time.val()).getTime() + 60 * 60 * 3 * 1000)));
			
			var strt = event_start_date_time.val().split(' ');
			var strt_hr = strt[1].split(':');
			
			strt[1] = (parseInt(strt_hr[0])+3)+':'+strt_hr[1]
			
			var endd = event_end_date_time.val().split(' ');
			//return false;
			var chkdate = 0;
			
			endd[1] = parseInt(endd[1].replace(':', ''), 10); 
			strt[1] = parseInt(strt[1].replace(':', ''), 10); 
			
			if(strt[0]==endd[0])
			{
				
				if(endd[1]<strt[1])
				{
					event_end_date_time.focus();
					eventenddatetimeInfo.text(validat_js_end_date_min_start_date);
					eventenddatetimeInfo.addClass("error1");
					
					$('html, body').animate({
	                    scrollTop: event_end_date_time.offset().top
	                }, 200);
		         	
					return false;
				}
			}else if(event_end_date_time.val() < event_start_date_time.val()){
				event_end_date_time.focus();
				eventenddatetimeInfo.text(validat_js_end_date_greater_start_date);
				eventenddatetimeInfo.addClass("error1");
				
				$('html, body').animate({
                    scrollTop: event_end_date_time.offset().top
                }, 200);
	         	
				return false;
			}else{}
			
			
			
			if(event_logo.val()==''){
				eventlogoInfo.text(validat_js_upload_logo_req);
				eventlogoInfo.addClass("error1");
				document.getElementById('err1').style.display = 'block';
				
				$('html, body').animate({
                    scrollTop: $("#err1").offset().top
                 }, 200);
	         	
				return false;
			}
			
			if(event_detail.val()=='&nbsp;' || event_detail.val()==''){
				event_detail.focus();
				eventdetailInfo.text(validat_js_event_details_req);
				eventdetailInfo.addClass("error1");
				
				$('html, body').animate({
                    scrollTop: eventdetailInfo.offset().top
                }, 200);
	         	
				return false;
			} 
			
			if($('#organizers_count').val()>0){
				if((org_event_id.val()==0 || org_event_id.val()=='' || org_event_id.val()=='0')){
					organizererrorInfo.text(validat_js_org_host_req);
					organizererrorInfo.addClass("error1");
					
					$('html, body').animate({
	                    scrollTop: organizererrorInfo.offset().top
	                }, 200);
		         	
					return false;
				}
			}else{
				if((org_event_id.val()==0 || org_event_id.val()=='' || org_event_id.val()=='0') && event_organizer_host.val()==''){
					organizererrorInfo.text(validat_js_org_host_req);
					organizererrorInfo.addClass("error1");
					
					$('html, body').animate({
	                    scrollTop: organizererrorInfo.offset().top
	                }, 200);
	                
					return false;
				}
			}
			
			
				var fb_val = event_facebook_link.val();
			if (fb_val.substring(0, 8) == "https://" || fb_val.substring(0, 7) == "http://" || fb_val.substring(0, 4) == "www." ){
				event_facebook_link_err.addClass("error1");
				event_facebook_link_err.text("Please enter a valid link");
				return false;	
			}
			var tw_val = event_twitter_link.val();
			if (tw_val.substring(0, 8) == "https://" || tw_val.substring(0, 7) == "http://" || tw_val.substring(0, 4) == "www." ){
				event_twitter_link_err.addClass("error1");
				event_twitter_link_err.text("Please enter a valid link");
				return false;	
			}
			
			
			
				var submit_type_val = submit_type.val();
			
			if (submit_type_val=='live')
				{
				
				var div_style = $("#main_ticket_head").css("display");
				 if(div_style=="none") {
				 var tickets_div = $("#ticket_error");
				 tickets_div.text("Minimum 1 Ticket Required to Make Event Live");
				 tickets_div.addClass("error1");
				 return false ;
				 }	
				 else{
				 var tickets_div = $("#ticket_error");
				 tickets_div.text("");
				 tickets_div.addClass("error1");
				 //return true ;
				 }
				}else{
			}


	     // private event password check
			var passwordInfo=$("#pass_div");
	 
			if ($("#event_password_protect").prop("checked")) {
		   		
		   	var a = $("#event_password_value");	
		      
		    	var passwordexp = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z](?=.*\W).{8,25}$/;
		    	var filter = passwordexp;
		    	
		      	var xyx = a.val() ;
		    	
				if(a.val()==''){
					//password.addClass("error1");
					
					passwordInfo.text("Password is required");
					passwordInfo.addClass("error1");
					return false;
				}
				else if(xyx.length<3 || xyx.length>=25){
					
					passwordInfo.text("Password should be between 3-25 characters.");
					passwordInfo.addClass("error1");
					return false;
				}
		   		
		   }
			
			// private event password check end
			
			//alert(4);
			var chks_name_free = document.getElementsByName('ticket[free_ticket_name][]');
			var chks_name_paid = document.getElementsByName('ticket[paid_ticket_name][]');
			var chks_name_don = document.getElementsByName('ticket[donation_ticket_name][]');
			
			var f1 = true;
			
			for (var i = 0; i < chks_name_free.length-1; i++) {   if(chks_name_free[i].value=='') {       f1 = false;   }    }
	        for (var i = 0; i < chks_name_paid.length-1; i++) {   if(chks_name_paid[i].value=='') {       f1 = false;   }    } 
	        for (var i = 0; i < chks_name_don.length-1; i++)  {   if(chks_name_don[i].value=='') {   f1 = false;   }    }
	         
	        if(f1==false){
	         	ticket_req_fields.text(validat_js_ticket_name_req);
	         	ticket_req_fields.show();
	         	 $('html, body').animate({
                    scrollTop: $("#ticket_req_fields").offset().top
                     }, 200);
	         	
	         	return false;
	        }
	        
			
	        
			var chks_qty_free = document.getElementsByName('ticket[free_qty][]');
			var chks_qty_paid = document.getElementsByName('ticket[paid_qty][]');
			var chks_qty_don = document.getElementsByName('ticket[donation_qty][]');
			
			var f2 = true;
			
			for (var i = 0; i < chks_qty_free.length-1; i++) {   if(chks_qty_free[i].value=='') {   f2 = false;   }    }
	        for (var i = 0; i < chks_qty_paid.length-1; i++) {   if(chks_qty_paid[i].value=='') {   f2 = false;   }    } 
	        for (var i = 0; i < chks_qty_don.length-1; i++)  {   if(chks_qty_don[i].value=='') {   f2 = false;   }    }
	        
	         
	        if(f2==false){
	         	ticket_req_fields.text(validat_js_ticket_qty_req);
	         	ticket_req_fields.show();
	         	$('html, body').animate({
                    scrollTop: $("#ticket_req_fields").offset().top
                     }, 200);
	         	
	         	return false;
	        }
	        
	        var chks_paid_price = document.getElementsByName('ticket[paid_price][]');
			var f3 = true;
			
			for (var i = 0; i < chks_paid_price.length-1; i++) {   if(chks_paid_price[i].value=='') {   f3 = false;   }    }
	         
	        if(f3==false){
	         	ticket_req_fields.text(validat_js_ticket_price_req);
	         	ticket_req_fields.show();
	         	$('html, body').animate({
                    scrollTop: $("#ticket_req_fields").offset().top
                     }, 200);
	         	
	         	return false;
	        }
	         
	        
	        var chks_start_free = document.getElementsByName('ticket[free_start_sale][]');
			var chks_start_paid = document.getElementsByName('ticket[paid_start_sale][]');
			var chks_start_don = document.getElementsByName('ticket[donation_start_sale][]');
			
			 
	          
			var chks_end_free = document.getElementsByName('ticket[free_end_sale][]');
			var chks_end_paid = document.getElementsByName('ticket[paid_end_sale][]');
			var chks_end_don = document.getElementsByName('ticket[donation_end_sale][]');
			
			
			var f4 = true;
			
			for (var i = 0; i < chks_start_free.length-1; i++) {   if(chks_start_free[i].value > chks_end_free[i].value) {   f4 = false;   }    }
	        for (var i = 0; i < chks_start_paid.length-1; i++) {   if(chks_start_paid[i].value > chks_end_paid[i].value) {   f4 = false;   }    } 
	        for (var i = 0; i < chks_start_don.length-1; i++)  {   if(chks_start_don[i].value > chks_end_don[i].value) {   f4 = false;   }    }
	        
	        
	        if(f4==false){
	         	ticket_req_fields.text(validat_js_ticket_start_date_not_grater_end_date);
	         	ticket_req_fields.show();
	         	$('html, body').animate({
                    scrollTop: $("#ticket_req_fields").offset().top
                     }, 200);
	         	
	         	return false;
	        }
	        
			
			var f5 = true;
			
			for (var i = 0; i < chks_end_free.length-1; i++) {   if(chks_end_free[i].value > event_end_date_time.val()) {   f5 = false;   }    }
	        for (var i = 0; i < chks_end_paid.length-1; i++) {   if(chks_end_paid[i].value > event_end_date_time.val()) {   f5 = false;   }    } 
	        for (var i = 0; i < chks_end_don.length-1; i++)  {   if(chks_end_don[i].value > event_end_date_time.val()) {   f5 = false;   }    }
	        
	        
	        if(f5==false){
	         	ticket_req_fields.text(validat_js_ticket_end_date_not_grater_end_date);
	         	ticket_req_fields.show();
	         	$('html, body').animate({
                    scrollTop: $("#ticket_req_fields").offset().top
                     }, 200);
	         	
	         	return false;
	        }
	       //alert(1)
	       var ajaxres = 1;
			if(event_event_url_link.val()!=''){
			//alert(2)
				var a = event_event_url_link.val();
				var filter = custom_url;
				//if it's NOT valid
				if(!filter.test(a)){
					event_event_url_link.focus();
					eventurllinkInfo.text(validat_js_valid_alpha_numeric);
					eventurllinkInfo.addClass("error1");
					return false;
				}
				
				
				var page_path = '/events/event_url_link/';
		        
		        $.ajax({
		            type: "POST",
		            data: {val: a}, 
		            url: page_path,
		            success: function(data) {
		               //alert(data);
		                if(data.msg!='success'){
		                	//alert(1);
		                	event_event_url_link.focus();
							eventurllinkInfo.text(data.msg);
							eventurllinkInfo.addClass("error1");
							ajaxres=0;
								return false;
		                }
		                
		            }
		        });
		        
		       
		        if(ajaxres==0){
			       	return false;
			     }
		        
			}
			   
			return true;
				
		});
		
	
	
	
	
	
	
	
	}

	
	function validate_request_api(){
		
		
		var form = $("#requestapiForm");	
		
	
		var first_name = $("#first_name");
		var firstnameInfo = $("#firstnameInfo");
		
		var last_name = $("#last_name");
		var lastnameInfo = $("#lastnameInfo");
		
		var company = $("#company");
		var companyInfo = $("#companyInfo");
		
		var phone = $("#phone");
		var phoneInfo = $("#phoneInfo");
	
		var app_url = $("#app_url");
		var appurlInfo = $("#appurlInfo");
		
		var redirect_uri = $("#redirect_uri");
		var redirecturiInfo = $("#redirecturiInfo");
		
		var app_name = $("#app_name");
		var appnameInfo = $("#appnameInfo");
	
		var desc = $("#desc");
		var descInfo = $("#descInfo");
	
		var terms = $("#terms");
		var termsInfo = $("#termsInfo");
	
		
		//set all errors null 
		firstnameInfo.text("");
		lastnameInfo.text("");
		companyInfo.text("");
		phoneInfo.text("");
		appurlInfo.text("");
		appnameInfo.text("");
		descInfo.text("");
		termsInfo.text("");
		
		//On Submitting
		form.submit(function(){
			
			if(first_name.val()==''){
				first_name.focus();
				firstnameInfo.text("First Name field is required.");
				firstnameInfo.addClass("error1");
				return false;
			}
			
			
			if(last_name.val()==''){
				last_name.focus();
				lastnameInfo.text("Last Name field is required.");
				lastnameInfo.addClass("error1");
				return false;
			}
			if(company.val()==''){
				company.focus();
				companyInfo.text("Company Name field is required.");
				companyInfo.addClass("error1");
				return false;
			}
			
			
			
			if(phone.val()==''){
				
				phone.focus();
				phoneInfo.text("Phone Number field is required.");
				phoneInfo.addClass("error1");
				return false;
			}
			
			if(app_url.val()==''){
				app_url.focus();
				appurlInfo.text("Application URL field is required.");
				appurlInfo.addClass("error1");
				return false;
			}
			
			if(app_url.val()!=''){
				var filter = url_reg_exp;
				if(!filter.test(app_url.val())){
					app_url.focus();
					appurlInfo.text("Type a valid Application URL.");
					appurlInfo.addClass("error1");
					return false;	
				}
			}
				
			if(redirect_uri.val()!=''){
				var filter = url_reg_exp;
				if(!filter.test(redirect_uri.val())){
					redirect_uri.focus();
					redirecturiInfo.text("Type a valid OAuth Redirect URL.");
					redirecturiInfo.addClass("error1");
					return false;	
				}
			}
					
				
			if(app_name.val()==''){
				app_name.focus();
				appnameInfo.text("Application name field is required.");
				appnameInfo.addClass("error1");
				return false;
			}
			
			
			if(desc.val()==''){
				desc.focus();
				descInfo.text("Description field is required.");
				descInfo.addClass("error1");
				return false;
			}
			
			
			if(terms.is(':checked')==false){
				termsInfo.text("Accept Terms & Conditions...!!");
				termsInfo.addClass("error1");
				return false;
			}
			
			
			return true;
				
		});
		
	
	
	
	
	
	}
	
	
	function validate_orgprofileForm(){
		//alert('hi');
		var form = $("#orgprofileForm");	
		//alert(1);
		var name = $("#name");
		var orgnameerrInfo = $("#orgnameerrInfo");
		//alert(2);
		var org_logo = $("#org_logo");
		var orglogoInfo = $("#err1");
		
		var org_detail = $("#org_detail");
		var orgdetailInfo = $("#orgdetailInfo");
		
		var show_website = $("#show_website");
		var websiteInfo = $("#websiteInfo");
		
		var show_category = $("#show_category");
		var categoryInfo = $("#categoryInfo");
		
		var show_location = $("#show_location");
		var cityInfo = $("#cityInfo");
		
		var page_url = $("#page_url");
		var changeprofileInfo = $("#changeprofileInfo");
	
		var add_facebook = $("#add_facebook");
		var facebookInfo = $("#facebookInfo");
		
		var add_twitter = $("#add_twitter");
		var add_search = $("#add_search");
		var twitterInfo = $("#twitterInfo");
		
		
		
	
		
		//set all errors null 
		orgnameerrInfo.text("");
		orglogoInfo.text("");
		orgdetailInfo.text("");
		
		websiteInfo.text("");
		categoryInfo.text("");
		cityInfo.text("");
		changeprofileInfo.text("");
		facebookInfo.text("");
		twitterInfo.text("");
		$('#err1').hide();
		
		//On Submitting
		form.submit(function(){
			
			if(name.val()==''){
				name.focus();
				orgnameerrInfo.text(validat_js_org_name_req);
				orgnameerrInfo.addClass("error1");
				return false;
			}
					
			if(org_logo.val()==''){
				orglogoInfo.text(validat_js_org_logo_req);
				orglogoInfo.addClass("error1");
				$('#err1').show();
				return false;
			}
			
			if(org_detail.val()==''){
				orgdetailInfo.text(validat_js_about_org_req);
				orgdetailInfo.addClass("error1");
				return false;
			}
			
			
			if (show_website.is(':checked')) {
				var a = $('#website').val();
				var filter = url_reg_exp;
				//if it's valid url
					if(a==''){
						$('#website').focus();
						websiteInfo.text(validat_js_wesite_field_req);
						websiteInfo.addClass("error1");
						return false;
					}
					
					//if it's NOT valid
					if(!filter.test(a)){
						$('#website').focus();
						websiteInfo.text(validat_js_type_valid_website_url);
						websiteInfo.addClass("error1");
						return false;
					}
			}	
			
			
			if(show_category.is(':checked')){
				var cat1 = $('#category1');
				var cat2 = $('#category2');
				
				if(cat1.val()=='' && cat2.val()==''){
					cat1.focus();
					categoryInfo.text(validat_js_min_one_category_req);
					categoryInfo.addClass("error1");
					return false;
				}
				
			}
			
			if(show_location.is(':checked')){
				var city1 = $('#city1');
				var city2 = $('#city2');
				
				if(city1.val()=='' && city2.val()==''){
					city1.focus();
					cityInfo.text(validat_js_min_one_city_req);
					cityInfo.addClass("error1");
					return false;
				}
				
			}
			
			
			if(page_url.val()!=''){
				
				var a = page_url.val();
				var filter = alphanum;
				//if it's valid email
		
				if(a==''){
					page_url.focus();
					changeprofileInfo.text(validat_js_enter_valid_alpha_numeric);
					changeprofileInfo.addClass("error1");
					return false;
				}
				//if it's NOT valid
				if(!filter.test(a)){
					page_url.focus();
					changeprofileInfo.text(validat_js_type_valid_alpha_numeric);
					changeprofileInfo.addClass("error1");
					return false;
				}
			}
			
			if(add_facebook.is(':checked')){
				
				var a = $('#facebook_link').val();
				var filter = fbusername;
				//if it's valid url
					if(a==''){
						$('#facebook_link').focus();
						facebookInfo.text(validat_js_enter_valid_alpha_numeric);
						facebookInfo.addClass("error1");
						return false;
					}
					
					//if it's NOT valid
					if(!filter.test(a)){
						$('#facebook_link').focus();
						facebookInfo.text(validat_js_type_only_numeric_char);
						facebookInfo.addClass("error1");
						return false;
					}
			}
			
			if(add_twitter.is(':checked')){
				
				if($('#add_username').is(':checked')){
					var a = $('#twitter_link').val();
					var filter = twusername;
					//if it's valid url
						if(a==''){
							$('#twitter_link').focus();
							twitterInfo.text(validat_js_enter_valid_alpha_numeric);
							twitterInfo.addClass("error1");
							return false;
						}
						
						//if it's NOT valid
						if(!filter.test(a)){
							$('#twitter_link').focus();
							twitterInfo.text(validat_js_type_only_numeric_char_and);
							twitterInfo.addClass("error1");
							return false;
						}
				}
				
			}
			
			if(add_search.is(':checked')){
				
				var a = $('#search_link').val();
				var filter = twusername;
				//if it's valid url
					if(a==''){
						$('#search_link').focus();
						twitterInfo.text(validat_js_enter_valid_alpha_numeric);
						twitterInfo.addClass("error1");
						return false;
					}
					
					//if it's NOT valid
					if(!filter.test(a)){
						$('#search_link').focus();
						twitterInfo.text(validat_js_type_only_numeric_char_and);
						twitterInfo.addClass("error1");
						return false;
					}
			}
			
			return true;
				
		});
		
	
	
	}

	function validate_newcontactForm(){
		var form = $("#newcontactForm");	
		
	
		var contact_list_name = $("#contact_list_name");
		var contactlistnameInfo = $("#contactlistnameInfo");
		
		var upload_datafile = $("#upload_datafile");
		var uploaddatafileInfo = $("#uploaddatafileInfo");
		
		var emails = $("#emails");
		var emailsInfo = $("#emailsInfo");
		
		
		var fetch_type1 = $("#fetch_type1");
		//var fetch_type2 = $("#fetch_type2");
		//var fetch_type3 = $("#fetch_type3");
		var fetch_type4 = $("#fetch_type4");
		
		//set all errors null 
		contactlistnameInfo.text("");
		uploaddatafileInfo.text("");
		emailsInfo.text("");
		
		
		//On Submitting
		form.submit(function(){
			
			if(contact_list_name.val()==''){
				 contact_list_name.focus();
				 contactlistnameInfo.text(validate_js_contactname_req);
				 contactlistnameInfo.addClass("error1");
				 return false;
			}
			
			if(fetch_type1.is(':checked') || fetch_type4.is(':checked')) //|| fetch_type2.is(':checked') || fetch_type3.is(':checked')
			{
				if (fetch_type1.is(':checked')) {
					chks = upload_datafile;
					if (chks.val()=='')
	                {
	                        upload_datafile.focus();
							uploaddatafileInfo.text(validate_js_upload_csv);
							uploaddatafileInfo.addClass("error1");
							
							return false;
	                }
					else 
					{
							value = chks.val();
							
							t1 = value.substring(value.lastIndexOf('.') + 1,value.length);
							
							if( t1!='csv')
							{
								upload_datafile.focus();
								uploaddatafileInfo.text(validate_js_invalid_file);
								uploaddatafileInfo.addClass("error1");
								
								return false;
							}
							
					}	
				}
				
				/*if (fetch_type2.is(':checked')) {
					return false;
				}	
				
				if (fetch_type3.is(':checked')) {
					return false;	
				}	*/
				
				if (fetch_type4.is(':checked')) {
					if(emails.val()==''){
						  emails.focus();
						 emailsInfo.text(validate_js_atleast_one);
						 emailsInfo.addClass("error1");
						 return false;
					}else{
						
						var mails = emails.val().split('\n');
						for (var i = 0; i < mails.length; i++)
				        {
				        	var cmmails = mails[i].split(',');
				            for (var j = 0; j < cmmails.length; j++)
				        	{
				        		var a = cmmails[j];
								var filter = email_reg_exp;
								//if it's valid email
								
								if(a!=''){
									if(!filter.test(a)){
										emails.focus();	
										emailsInfo.text(validate_js_valid_email);
										emailsInfo.addClass("error1");
										return false;
									}
								}
				        	}	
				            //alert(mails[i]);
				         }
						
					}
				}
					
			}else{
				 
				 emailsInfo.text(validate_js_atleast_one);
				 emailsInfo.addClass("error1");
				 return false;
			}
			return true;
				
		});
		
	
	}
	
	setTimeout(function() {
	$('.error1').fadeOut("slow");
	}, 5000 );
	
	setTimeout(function() {
	$('.notice').fadeOut("slow");
	}, 5000 );

	
	

});