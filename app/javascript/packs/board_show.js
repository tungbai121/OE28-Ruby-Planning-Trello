$(function() {
  $('#close-menu').click(function() {
    if ($('#close-menu').hasClass('open')) {
      $('#board-menu').css('width', '0px');
      $('#board-menu').css('padding', '0px');
      $('#close-menu').removeClass('open');
      $('#open-menu').css('transform', 'translateX(0px)');
    }
  });

  $('#open-menu').click(function() {
    if ($('#close-menu').hasClass('open')) {
      $('#close-menu').removeClass('open');
      $('#board-menu').css('width', '0px');
      $('#board-menu').css('padding', '0px');
      $('#open-menu').css('transform', 'translateX(0px)');
    }
    else {
      $('#board-menu').css('width', '300px');
      $('#board-menu').css('padding', '10px 10px');
      $('#close-menu').addClass('open');
      $('#open-menu').css('transform', 'translateX(-300px)');
    }
  });

  $('#edit').click(function() {
    if ($('#board-name').hasClass('input')) {
      $('#board-name').css('display', 'none');
      $('#board-name-form').css('display', 'block');
      $('#board-name').removeClass('input');
      $('#edit').text('edit');
    }
    else {
      $('#board-name').css('display', 'block');
      $('#board-name-form').css('display', 'none');
      $('#board-name').addClass('input');
      $('#edit').text('close');
    }
  });

  $(document).mouseup(function (e) {
    var container = $('.add');
    if (!container.is(e.target) && container.has(e.target).length === 0)
      container.find('.collapse').removeClass('show');
  });

  $.ajaxSetup({
    headers: {'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')}
  });

  $('.tags').sortable({
    connectWith: '.tags',
    cursor: 'grabbing',
    placeholder: 'sortable-placeholder',
    start: function(e, ui){
      ui.placeholder.height(ui.item.height());
      ui.item.addClass('tilt');
      tilt_direction(ui.item);
    },
    update: function(e, ui) {
      tagIds = $(this).sortable('serialize');
      sortableId = $(this).parent().attr('id');
      listId = sortableId.split('-').pop();
      params = tagIds.concat('&&list[]=', listId);

      $.ajax({
        url: $(this).data('url'),
        type: 'PATCH',
        data: params
      });
    },
    stop: function (event, ui) {
      ui.item.removeClass('tilt');
    }
  });

  function tilt_direction(item) {
    var left_pos = item.position().left,
      move_handler = function(e) {
        if (e.pageX >= left_pos) {
          item.addClass('right');
          item.removeClass('left');
        } else {
          item.addClass('left');
          item.removeClass('right');
        }
        left_pos = e.pageX;
      };
    $('html').bind('mousemove', move_handler);
    item.data('move_handler', move_handler);
  };

  $('.tag').addClass('ui-widget ui-widget-content ui-helper-clearfix ui-corner-all')
           .find('.tag-header')
           .addClass('ui-widget-header ui-corner-all')
           .prepend('<span class="ui-icon ui-icon-minusthick tag-toggle"></span>');

  $('.tag-toggle').click(function() {
    var icon = $(this);
    icon.toggleClass('ui-icon-minusthick ui-icon-plusthick');
    icon.closest('.tag').find('.tag-body').toggle();
  });
});
