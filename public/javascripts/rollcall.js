(function($) {
  $(function() {
    // HIPAA Stuff
    var toggleHIPAA = function() {
      if ($(this).find(':selected[data-hipaa]').length > 0) {
        $('.hipaa').show();
      } else {
        $('.hipaa').hide();
      }
    }
    $('.hipaa-control select').live('change', toggleHIPAA);
    $('.hipaa-control select').trigger('change');
    
    $(document).ready(function() {
      $('.datepicker').datepicker({
        showOn: 'both',
        buttonImage: '/images/schedule.png',
        buttonImageOnly: true,
        minDate: 0
      });
      
      $("#wrapper").css({"width":"850px"})
      $(".school_selection select#district_id").change(function() {
        $(".school_selection select#school_id option:selected").attr('selected', '');
        $(".school_selection select#school_id option:first").attr('selected', 'selected');
        $("form").submit();
      });

      $("ul.school_alerts").hide();
      $("ul.schools").hide();
    });
    $("ul.district a.district_name").click(function()
    {
      $("ul.schools", $(this).parent()).toggle("slide", {direction:"up"});
      $("span.more").hide();
      expander=$("span.expander", $(this).parent());
      expander.text(expander.text() == ">>" ? "<<" : ">>");
    });
    $("a.school_name").click(function(){
      $("ul.school_alerts", $(this).parent().parent()).toggle("slide", {direction:"up"});
      $("span.more", $(this).parent().parent()).toggle();
      $(this).parent().parent().toggleClass('school_bordered');
    });
  });
})(jQuery);