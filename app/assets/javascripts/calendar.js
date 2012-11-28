function initCalendar(sauna_item_id) {

	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();
	
	$('#calendar').fullCalendar({
		editable: false,        
		header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        defaultView: 'month',
        height: 300,
        slotMinutes: 60,		
		allDaySlot : false,
        timeFormat: 'H:mm { - H:mm} ',
		selectable: true,
		selectHelper: true,	
		lazyFetching: true,

        eventSources: [{
            url: '/bookings?sauna_item_id='+sauna_item_id,
            color: 'yellow',
            textColor: 'black',
            ignoreTimezone: false
        }],   

		dayClick: function(date, allDay, jsEvent, view) {
		   $('#calendar').fullCalendar('gotoDate', date);
		   $('#calendar').fullCalendar('changeView', 'agendaDay');
        },	
			
		select: function(start, end, allDay) {
			$('#calendar').fullCalendar('removeEvents', 'draft');
			
			var title="Бронирование";
			if (title) {
				var eventObj = 	{
					id: 'draft',
					title: title,
					start: start,
					end: end,
					allDay: allDay
				};		

				var is_valid = true;
				var bookings = $('#calendar').fullCalendar('clientEvents');
				for (i in bookings) {
					if (bookings[i].start.getDate() == end.getDate() || bookings[i].end.getDate() == start.getDate()) {
						if (bookings[i].start < end && end < bookings[i].end) {
							is_valid = false;							
						}					
						if (bookings[i].start < start && start < bookings[i].end) {
							is_valid = false;
						}	
						if (start <= bookings[i].start && bookings[i].end <= end) {
							is_valid = false;
						}						
					}
				}
				
				if (is_valid) {					
					$('#calendar').fullCalendar('renderEvent', eventObj, true);
				} else {
					alert("На выбранное вами время сауна уже забронирована!");
				}
			}
			$('#calendar').fullCalendar('unselect');
		}
		
	});
}