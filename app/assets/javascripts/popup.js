$(document).ready(function() {   
    //if close button is clicked
    $('.window .close').click(function (e) {
        //Cancel the link behavior
        e.preventDefault();
        $('#mask, .window').hide();
    });     
     
    //if mask is clicked
    $('#mask').click(function () {
        $(this).hide();
        $('.window').hide();
    });         
    
	$(window).resize(function () {	  
			var box = $('#boxes .window');
	  
			//Get the screen height and width
			var maskHeight = $(document).height();
			var maskWidth = $(window).width();
		   
			//Set height and width to mask to fill up the whole screen
			$('#mask').css({'width':maskWidth,'height':maskHeight});		
			
			//Get the window height and width
			var winH = $(window).height();
			var winW = $(window).width();
	  
			//Set the popup window to center
			box.css('top',  winH/2 - box.height()/2);
			box.css('left', winW/2 - box.width()/2);	  			
	});	

	$("#new_booking").submit(function() { 
		submitContactFormPopup();
	});	
	
});

function showSelectPaymentPopup(){
	removeSpin();	
	closePopup();
	initPopup('#dialog-select-payment');
}

function showPaymentPopup(id){
	initPopup(id);
}

function showContactFormPopup(id){
	var today = new Date();	
	today.setDate(today.getDate()+1);
	
	var start_date = $('#calendar').fullCalendar( 'clientEvents', 'draft' )[0].start;						
	var end_date = $('#calendar').fullCalendar( 'clientEvents', 'draft' )[0].end;
	
	if (start_date < today) {
		// show error
		alert("Невозможно создать бронирование на дату, раньше текущей.");
		$('#calendar').fullCalendar('removeEvents', 'draft');
		return false;
	} else {
		// go to the contact form
		closePopup();
		initPopup(id);
			
		$('#dialog-contact .error').hide();
		$('#booking_starts_at').val(start_date);
		$('#booking_ends_at').val(end_date);

		var str_date = start_date.getDate() + "." + start_date.getMonth() + "." + start_date.getFullYear();
		var str_start_time = start_date.getHours();	
		var str_end_time = end_date.getHours();	
		
		$('#booking_date').html(str_date);
		$('#booking_time').html("с " + str_start_time + " до " + str_end_time + " часов");
		
		var old_height = parseInt($('#popup_height').val());
		$('#dialog-contact').height(old_height);	
		
		enableContactFormPopup();		
	}
}

function submitContactFormPopup(){
	disableContactFormPopup();	
	createSpin('dialog-contact');
	return true;
}

function disableContactFormPopup(){
	$('#dialog-contact input[type=submit]').prop('disabled', true);
	$('#dialog-contact textarea').prop('disabled', true);
}

function enableContactFormPopup(){
	$('#dialog-contact input[type=submit]').prop('disabled', false);
	$('#dialog-contact textarea').prop('disabled', false);
}

function showCalendarPopup(id, sauna_id){
	initPopup(id);	
	initCalendar(sauna_id);	
}

function showCalendarPopupAdmin(id, sauna_id){
	initPopup(id);
	initCalendar(sauna_id);		
	$('#booking_sauna_id').val(sauna_id);
}

function showContactFormPopupAdmin(id){
	var start_date = $('#calendar').fullCalendar( 'clientEvents' )[0].start;						
	var end_date = $('#calendar').fullCalendar( 'clientEvents' )[0].end;
	closePopup();
	initPopup(id);
	
	$('#booking_fio').val('');
	$('#booking_phone_number').val('');
	$('#booking_email').val('');
	$('#booking_description').val('');
	
	$('#booking_starts_at').val(start_date);
	$('#booking_ends_at').val(end_date);			
}

function showBookingInfoPopupAdmin(id, booking_id){	
	initPopup(id);		
	$.get('/admin/bookings/'+booking_id, function(data) {	
		 var str = $('#booking_desc').html();
		 var row_count = str.length / 30 ;
		 var add_height = row_count * 15 ;
		 var old_height = parseInt($('#popup_height').val());
		 $('#dialog-booking').height(old_height + add_height);
	});
}

function initPopup(id){
	//Get the screen height and width
	var maskHeight = $(document).height();
	var maskWidth = $(window).width();
 
	//Set height and width to mask to fill up the whole screen
	$('#mask').css({'width':maskWidth,'height':maskHeight});
	 
	//transition effect     
	$('#mask').fadeIn(1000);    
	$('#mask').fadeTo("slow",0.8);  
 
	//Get the window height and width
	var winH = $(window).height();
	var winW = $(window).width();
		   
	//Set the popup window to center
	$(id).css('top',  winH/2-$(id).height()/2);
	$(id).css('left', winW/2-$(id).width()/2);
	
	//transition effect
	$(id).fadeIn(1000); 
}

function closePopup(){
	$('#mask, .window').hide();
}

function createSpin(target_id){
	var opts = {
	  lines: 10, // The number of lines to draw
	  length: 30, // The length of each line
	  width: 12, // The line thickness
	  radius: 40, // The radius of the inner circle
	  color: '#000', // #rgb or #rrggbb
	  speed: 1, // Rounds per second
	  trail: 100, // Afterglow percentage
	  shadow: false, // Whether to render a shadow
	  hwaccel: false, // Whether to use hardware acceleration
	  className: 'spinner', // The CSS class to assign to the spinner
	  zIndex: 2e9, // The z-index (defaults to 2000000000)
	  top: 'auto', // Top position relative to parent in px
	  left: 'auto' // Left position relative to parent in px
	};
	var target = document.getElementById(target_id);
	var spinner = new Spinner(opts).spin(target);
	return spinner;
}

function removeSpin(){
	$('.spinner').remove();
}