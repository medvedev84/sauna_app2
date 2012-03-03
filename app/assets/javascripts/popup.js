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
});

function showSelectPaymentPopup(){
	initPopup('#dialog-select-payment');
}

function showPaymentPopup(id){
	initPopup(id);
}

function showContactFormPopup(id){
	var start_date = $('#calendar').fullCalendar( 'clientEvents' )[0].start;						
	var end_date = $('#calendar').fullCalendar( 'clientEvents' )[0].end;
	closePopup();
	initPopup(id);
	$('#booking_starts_at').val(start_date);
	$('#booking_ends_at').val(end_date);	
}

function showCalendarPopup(id){
	initPopup(id);
	initCalendar();	
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

	initCalendar(); 
	
	//transition effect
	$(id).fadeIn(1000); 
}

function closePopup(){
	$('#mask, .window').hide();
}