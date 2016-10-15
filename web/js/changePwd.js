$(document).ready(function(){
    //$("#test").countdown({until:+10});
                
    jQuery.validator.addMethod("notEqual", function(value, element, param) {
        return this.optional(element) || value != $(param).val();
    }, "This has to be different...");

    $("#ChangePwd").validate({
                    
        rules: {
                        
            newpwd :{
                notEqual : "#oldpwd"
            },
                        
            renewpwd: {
                equalTo: "#newpwd"
            },
                    
            oldpwd :{
                remote:"CheckPwd"
            }
                        
        },
                    
        messages:{
                    
            oldpwd:{
                remote:"Please enter the present password"  
            },
                    
            newpwd:{
                notEqual : "Please choose a new password"
            },
            renewpwd: {
                equalTo: "Please Re-enter the new password"
            }
        },
                    
        submitHandler: function(form){
                        
            $("#mws-validate-error").hide();
                        
            jQuery(form).ajaxSubmit({
                            
                success: function(res,status,xhr,$form){
                            
                    if(status == "success")
                    {
                        $("#ChangePwd .mws-textinput").clearFields();
                        $("#success-msg").show().html('Password Changed Successfully');
                    }
                                
                }
                            
            });
                    
            return false;
        },
                    
        invalidHandler: function(form, validator) {
            var errors = validator.numberOfInvalids();
            if (errors) {
                var message = errors == 1
                ? 'You missed 1 field. It has been highlighted'
                : 'You missed ' + errors + ' fields. They have been highlighted';
                $("#validate-error").html(message).show();
            } else {
                $("#validate-error").hide();
            }
        }
    });
                
                
    $("#change-pwd-dialog").dialog({
        autoOpen: false, 
        title: "Change Password", 
        modal: true, 
        width: "640", 
        buttons: [{
            text: "Submit", 
            click: function() {
                $( this ).find('form#ChangePwd').submit();
            }
        },

        {
        text: "Close", 
        click: function() {
            $( this ).dialog("close");
        }
    }
    ]
});
                
$("#change-pwd").bind("click", function(event) {
    $("#change-pwd-dialog").dialog("option", {
        modal: true
    }).dialog("open");
    event.preventDefault();
    return false;
});
});