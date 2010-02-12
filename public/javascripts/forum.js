(function($) {
	
	$( document ) . ready ( 
	  function() {
	    $( 'div.new_topic' ).before( '<p><a class="show_hide_new_topic" href="#">Show New Topic</a></p>' );
	    $( 'div.new_topic' ).hide();
	    $('a.show_hide_new_topic').toggle ( 
	      function() {
	        $(this.parentNode.nextSibling).slideDown('slow');
	        $(this).html('Hide New Topic');
	      },
	      function() {
	        $(this.parentNode.nextSibling).slideUp('slow');
	        $(this).html('Show New Topic');
	      }
	    )
	  }
	)

	$( document ) . ready ( 
	  function() {
	    $( 'div.edit_comment' ).before( '<p><a class="show_hide_edit_comment" href="#">Show Edit Comment</a></p>' );
	    $( 'div.edit_comment' ).hide();
	    $('a.show_hide_edit_comment').toggle ( 
	      function() {
	        $(this.parentNode.nextSibling).slideDown('slow');
	        $(this).html('Hide Edit Comment');
	      },
	      function() {
	        $(this.parentNode.nextSibling).slideUp('slow');
	        $(this).html('Show Edit Comment');
	      }
	    )
	  }
	)

})(jQuery);


