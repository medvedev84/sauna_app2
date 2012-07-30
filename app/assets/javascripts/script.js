var Frame =
{
	settings: {

	},

	initMainPage: function()
	{
		this.initExpandedBoxes();
		this.initFilter();
		this.initSaunaSorting();
		this.initSearchBySaunaName();
		this.initDatePickerRegional();

		//временные действия
		$('._expandedBox h2').click(function()
		{
			var expandedBox = $(this).parent();
			var paramsBox = $(this).next();
			if (paramsBox.hasClass('extra_params'))
			{
				var checkedFlag = false;
				paramsBox.find('input:checked').each(function(){checkedFlag = true});

				if (checkedFlag)
				{
					expandedBox.find('._closed').html('&nbsp;');
				}
				else
				{
					expandedBox.find('._closed').html('неважно');
				}
			}
			if (paramsBox.hasClass('place_param'))
			{
				var checkedFlag = false;

				if (paramsBox.find('select').val() != 0)
				{
					expandedBox.find('._closed').html('&nbsp;');
				}
				else
				{
					expandedBox.find('._closed').html('неважно');
				}
			}
		})
	},

	initDetailPage: function()
	{
		this.initExpandedBoxes();
		this.initPhotoGallery();
		this.initDetailLeftMenu();
		this.initChain();
	},
	
	initExpandedBoxes: function()
	{
		$('._closeOnReady').each(function()
		{
			$(this).removeClass('expanded').addClass('closed').find('._closed').show();
			$(this).find('._expanded').hide();
		});

		$('._expandedBox h2').click(function()
		{
			var expandedBox = $(this).parents('._expandedBox').eq(0);
			expandedBox.toggleClass('closed').toggleClass('expanded');
			expandedBox.find('._expanded').toggle();
			expandedBox.find('._closed').toggle();
		});
	},

	initFilter: function()
	{
		$("#priceSlider").slider({
			range: true,
			min: 400,
			max: 2000,
			values: [$('#q_sauna_items_min_price_gteq').val(), $('#q_sauna_items_min_price_lteq').val()],
			slide: function(event, ui) {
				$('#q_sauna_items_min_price_gteq').val(ui.values[0]);
				$('#q_sauna_items_min_price_lteq').val(ui.values[1]);
			}
		});

		$("#capacitySlider").slider({
			range: true,
			min: 4,
			max: 20,
			values: [$('#q_sauna_items_capacity_gteq').val(), $('#q_sauna_items_capacity_lteq').val()],
			slide: function(event, ui) {
				$('#q_sauna_items_capacity_gteq').val(ui.values[0]);
				$('#q_sauna_items_capacity_lteq').val(ui.values[1]);
			}
		});
	},

	initSaunaSorting: function()
	{
		var saunaList = new Array();
		
		$('#saunaResultList li.row').each(function()
		{
			var id = $(this).attr('id');
			var photo_tag = $(this).find('.photo').html();
			var capacity = parseInt($(this).find('.capacity').text());
			var price = parseInt($(this).find('.price').text());
			var name = $(this).find('.s-name').text();
			var address = $(this).find('.address').text();			
			saunaList.push({
				'id': id,
				'name': name,			
				'address': address,
				'capacity': capacity,
				'price': price,
				'photo_tag': photo_tag
			})
		});

		var sortByCapacityAsc = function(i, j)
		{
			if (i.capacity > j.capacity)
				return 1;
			else if (i.capacity < j.capacity)
				return -1;
			else
				return 0;
		};

		var sortByCapacityDesc = function(j, i)
		{
			if (i.capacity > j.capacity)
				return 1;
			else if (i.capacity < j.capacity)
				return -1;
			else
				return 0;
		};

		var sortByPriceAsc = function(i, j)
		{
			if (i.price > j.price)
				return 1;
			else if (i.price < j.price)
				return -1;
			else
				return 0;
		};

		var sortByPriceDesc = function(j, i)
		{
			if (i.price > j.price)
				return 1;
			else if (i.price < j.price)
				return -1;
			else
				return 0;
		};

		var sortSaunaList = function(sortByField)
		{
			var sortedList = saunaList.sort(sortByField);

			var newListHTML = '<li class="head">' + $('#saunaResultList .head').html() + '</li>';
			
			for (var i in sortedList)
			{				
				//newListHTML += '<li class="row" id="' + sortedList[i].id + '">' + $('#' + sortedList[i].id).html() + '</li>';			                                                                                                                                                                                                                                                            
				newListHTML += '<li class="row" id="' + sortedList[i].id + '" ><a href="/saunas/' + sortedList[i].id + '" target="_blank"><span class="photo">' + sortedList[i].photo_tag + '</span><div class="name"><span class="s-name">' + sortedList[i].name + '</span><div class="address">' + sortedList[i].address + '</div></div><div class="capacity">до '+ sortedList[i].capacity +' чел.</div><div class="price">от '+ sortedList[i].price +' руб./час</div></a></li>';
			}

			$('#saunaResultList').empty().append(newListHTML);			
		};

		$('#saunaResultList .head .capacity').live('click', function()
		{
			var item = $(this);
					
			$('#saunaResultList .head .price').removeClass('asc').removeClass('desc')

			if (item.hasClass('desc'))
			{
				item.removeClass('desc').addClass('asc');
				sortSaunaList(sortByCapacityDesc);
			}
			else
			{
				item.removeClass('asc').addClass('desc');
				sortSaunaList(sortByCapacityAsc);
			}
		});

		$('#saunaResultList .head .price').live('click', function()
		{
			var item = $(this);

			$('#saunaResultList .head .capacity').removeClass('asc').removeClass('desc')

			if (item.hasClass('desc'))
			{
				item.removeClass('desc').addClass('asc');
				sortSaunaList(sortByPriceDesc);
			}
			else
			{
				item.removeClass('asc').addClass('desc');
				sortSaunaList(sortByPriceAsc);
			}						
		});
		
		$('#saunaResultList .head .price').click();			
	},
	
	initSearchBySaunaName: function()
	{
		$('#q_name_cont').val("Поиск сауны по названию");
		$('#q_name_cont').live('click', function()
		{
			$('#q_name_cont').val("");													
		});		
	},		
	
	initSearchByCustomerName: function(search_box_id)
	{
		$(search_box_id).val("Поиск бронирования по ФИО");
		$(search_box_id).live('click', function()
		{
			$(search_box_id).val("");													
		});		
	},		
	
	initDatePickerRegional: function() 
	{
		$.datepicker.setDefaults(
		  $.extend(
			{'dateFormat':'dd-mm-yy'},
			$.datepicker.regional['ru']
		  )
		);	
	},
	
	initSearchByMessageText: function()
	{
		$('#q_message_text_cont').val("Поиск сообщения по тексту");
		$('#q_message_text_cont').live('click', function()
		{
			$('#q_message_text_cont').val("");													
		});		
	},		
	
	initChain: function()
	{
		$('#sauna_address_district_id').chainedTo('#sauna_address_city_id');	
	},		

	initSearchCityDistrictChain: function()
	{
		$('#q_address_district_id_eq').chainedTo('#q_address_city_id_eq');				
	},	
	
	initSearchUserSaunaChain: function()
	{
		$('#q_booking_sauna_item_sauna_id_eq').chainedTo('#q_booking_sauna_item_sauna_user_id_eq');		
	},	

	initSearchSaunaSaunaItemChain: function()
	{
		$('#q_sauna_item_id_eq').chainedTo('#q_sauna_item_sauna_id_eq');		
	},	

	initPhotoGallery: function()
	{
		jQuery(document).ready(function($) {
			// We only want these styles applied when javascript is enabled
			$('div.navigation').css({'width' : '280px', 'float' : 'left'});

			// Initially set opacity on thumbs and add
			// additional styling for hover effect on thumbs
			var onMouseOutOpacity = 0.67;
			$('#thumbs ul.thumbs li').opacityrollover({
				mouseOutOpacity:   onMouseOutOpacity,
				mouseOverOpacity:  1.0,
				fadeSpeed:         'fast',
				exemptionSelector: '.selected'
			});

			// Initialize Advanced Galleriffic Gallery
			var gallery = $('#thumbs').galleriffic({
				delay:                     2500,
				numThumbs:                 15,
				preloadAhead:              10,
				enableTopPager:            false,
				enableBottomPager:         true,
				enableKeyboardNavigation:  false,
				maxPagesToShow:            7,
				imageContainerSel:         '#slideshow',
				controlsContainerSel:      '#controls',
				captionContainerSel:       '#caption',
				loadingContainerSel:       '#loading',
				renderSSControls:          true,
				renderNavControls:         true,
				playLinkText:              'Слайдшоу',
				pauseLinkText:             'Пауза',
				prevLinkText:              '&lsaquo;',
				nextLinkText:              '&rsaquo;',
				nextPageLinkText:          '&rsaquo;',
				prevPageLinkText:          '&lsaquo;',
				enableHistory:             false,
				autoStart:                 false,
				syncTransitions:           true,
				defaultTransitionDuration: 900,
				onSlideChange:             function(prevIndex, nextIndex) {
					// 'this' refers to the gallery, which is an extension of $('#thumbs')
					this.find('ul.thumbs').children()
						.eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end()
						.eq(nextIndex).fadeTo('fast', 1.0);
				},
				onPageTransitionOut:       function(callback) {
					this.fadeTo('fast', 0.0, callback);
				},
				onPageTransitionIn:        function() {
					this.fadeTo('fast', 1.0);
				}
			});
		});
	},

	initDetailLeftMenu : function()
	{
		$('#leftMenuDetail a').click(function(event)
		{
			$('#leftMenuDetail li').each(function(){
				$(this).removeClass('active');
			});
			$(this).parent().addClass('active');

			var numberActive = $("#leftMenuDetail li.active").index("#leftMenuDetail li");

			$('._saunaDetailDescription').each(function(){
				$(this).addClass('_saunaDetailDescriptionClosed');
			});

			$('._saunaDetailDescription').eq(numberActive).removeClass('_saunaDetailDescriptionClosed');

			event.preventDefault();
		});
	}
};

/*
	Author: MindFreakTheMon.com
	jQuery 1.3.* Required
	Script was tested on IE7,8; FF3.5; Opera 10.01;
	Chrome ans Safari understands HTML5-placeholder attribute, so there is no need in this script for them.
*/

(function($)
{
	if(!$) return false;

	$.fn.extend({
		storeEvents: function(b)
		{
			return this.each(function()
			{
				var copy = function(j)
				{
					var o = {};

					for(i in j)
					{
						o[i] = typeof(j[i]) == 'object' ? arguments.callee(j[i]) : j[i];
					}

					return o;
				};

				$.data(this, 'storedEvents', copy($(this).data('events')));

				if(b)
				{
					$(this).unbind();
				}
			});
		},
		restoreEvents: function(b)
		{
			return this.each(function()
			{
				var events = $.data(this, 'storedEvents');

				if(events)
				{
					if(!b)
					{
						$(this).unbind();
					}

					for(var type in events)
					{
						for(var handler in events[type])
						{
							$.event.add(this, type, events[type][handler], events[type][handler].data);
						}
					}
				}
			});
		},
		copyAttr: function(e, p, v)
		{
			return this.each(function()
			{
				var a = {}, i, n, m;

				if(p === true)
				{
					for(i = 0, v = $.makeArray(v); i < this.attributes.length; i++)
					{
						n = this.attributes[i].nodeName;
						m = this.attributes[i].nodeValue;

						if(m && $.inArray(n, v) == -1)
						{
							a[n] =m;
						}
					}
				}
				else
				{
					for(i = 0, p = $.makeArray(p); i < p.length; i++)
					{
						if(typeof $(this).attr(p[i]) == 'string')
						{
							a[p[i]] = $(this).attr(p[i]);
						}
					}
				}

				$(this).attr(a);
			});
		},
		blurfocus: function(options)
		{
			return this.each(function()
			{
				if($.browser.safari)
				{
					return false;
				}

				var text = $(this).attr('placeholder');
				options = $.extend({className: 'placeholded', handle_send: true, handle_password: true}, options || {});

				if($(this).is(':password') && options.handle_password)
				{
					$(this).data('placeholded_type', 'password');
				}

				var blur = function(e)
				{
					if($(this).val().length == 0)
					{
						if($(this).data('placeholded_type') == 'password')
						{
							var input = $('<input type="text" name="' + $(this).attr('name') + '" />'), events = $(this).storeEvents(true).data('storedEvents');
							$(this).copyAttr(input, true, ['type', 'name']).replaceWith(input);
							input.blur().data('placeholded_type', 'password').data('storedEvents', events).restoreEvents();
						}
						else
						{
							var input = $(this);
						}

						//input.attr('readonly', true).val(text).addClass(options.className);
						input.val(text).addClass(options.className);
					}
				}, focus = function(e)
				{
					if($(this).val() == text && $(this).hasClass(options.className))
					{
						if($(this).data('placeholded_type') == 'password')
						{
							var input = $('<input type="password" name="' + $(this).attr('name') + '" />'), events = $(this).storeEvents(true).data('storedEvents');
							$(this).copyAttr(input, true, ['type', 'name']).replaceWith(input);
							input.focus().data('placeholded_type', 'password').data('storedEvents', events).restoreEvents();
						}
						else
						{
							var input = $(this);
						}

						//input.val('').removeAttr('readonly').removeClass(options.className);
						input.val('').removeClass(options.className);
					}
				}, click = function()
				{
					focus.call(this);
					$(this).storeEvents(true).focus().restoreEvents();
				}, keydown = function(e)
				{
					if(e.keyCode == 9)
					{
						if(!$.browser.msie)
						{
							blur.call(this);
						}

						e.stopPropagation();
					}
				};

				if($(this).is(':password, :text, textarea'))
				{
					$(this).val($(this).val() == text ? '' : $(this).val()).blur(blur).focus(focus).click(click).keydown(keydown).blur();

					if(options.handle_send)
					{
						$(this).parents('form:eq(0)').each(function()
						{
							if($(this).data('placeholder_form') != 'handled')
							{
								events = $(this).data('placeholder_form', 'handled').storeEvents().data('storedEvents');
								eval('var anonfunc = function(){ ' + ($(this).attr('onsubmit') || '') + ' };');
								events.submit = $.extend(true, {'spec_sub': function(){ $(this).find('.' + options.className).focus(); }},  events.submit, {'anonfunc': anonfunc, 'spec_aft': function(e){ if(e.isDefaultPrevented()) $(this).find(':input').blur(); }});
								$(this).removeAttr('onsubmit').data('storedEvents', events).restoreEvents();
							}
						});
					}
				}
			});
		}
	});

	$(function()
	{
		$(":input[placeholder]").each(function(){ $(this).blurfocus($(this).attr('placeholder')); });
	});
})(jQuery);