// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function (){
	$('#menu_category_name').change(function(){
      $('#menu_field_changed').val('course_category');
      $.get(window.location, $('form').serialize(), null, "script");
  	  return false;
	});
});