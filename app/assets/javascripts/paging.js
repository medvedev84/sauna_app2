function selectPaginatorLink(url_path, current_number){
	// unselect old page
	var selected_number = $(".pagination .current").html().trim();
	var anchor_str = "<a rel='next' data-remote='true' href='" + url_path + "?page=" + selected_number + "'>" + selected_number + "</a>";
	$(".pagination .current").html(anchor_str);
	$(".pagination .page").removeClass("current");
	// select new page	
	current_number_selector = current_number;
	current_number_selector -= 1;
	var el = $(".pagination .page:eq("+ current_number_selector + ")");
	el.addClass("current");
	el.html(current_number);
}