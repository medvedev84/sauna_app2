function addPhoneNumberValidator(field_id, hidden_id){
	$(field_id).keyup(function() {
		var pattern = "+7-___-___-____";		
		var input = $(field_id).val();	
		var count = input.indexOf("_");		
		var new_value = input.substring(0, count) + pattern.substring(count);
		$(field_id).val(new_value);	 
		
		$(hidden_id).val(new_value.substring(1).replace(/-/gi,""));	
		
		if (input.charAt(count+1) == "-") {
			$(field_id).setCursorPosition(count+1);		
		} else {
			$(field_id).setCursorPosition(count);		
		}	
		
		if (checkPhoneNumber(new_value.substring(1))) {
			$(field_id).removeClass("field_error");
			$(field_id).addClass("field_correct");
		} else {
			$(field_id).removeClass("field_correct");
		}
		
	});	
}

function checkPhoneNumber(number){
	var pattern = /^[7-8]-\d{3}-\d{3}-\d{4}$/i;		
	var result=pattern.test(number);
	return result;
}	

function checkBeforeSubmit(field_id){
	var value = $(field_id).val();	
	if (!checkPhoneNumber(value.substring(1))) {
		$(field_id).addClass("field_error");
		return false;
	}
	return false;
}	

jQuery.fn.setCursorPosition = function(position){
	if(this.lengh == 0) return this;
	return $(this).setSelection(position, position);
}	

jQuery.fn.setSelection = function(selectionStart, selectionEnd) {
	if(this.lengh == 0) return this;
	input = this[0];
 
	if (input.createTextRange) {
		var range = input.createTextRange();
		range.collapse(true);
		range.moveEnd('character', selectionEnd);
		range.moveStart('character', selectionStart);
		range.select();
	} else if (input.setSelectionRange) {
		input.focus();
		input.setSelectionRange(selectionStart, selectionEnd);
	}
 
	return this;
}	

