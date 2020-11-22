$(document).on('turbolinks:load', function() {
  let other_emails = $('#other_emails').data('emails');
  $('#add-member-input').autocomplete({
    source: other_emails
  });

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

  $('#edit-board-name').click(function() {
    if ($('#board-name').hasClass('input')) {
      $('#board-name').css('display', 'none');
      $('#board-name-form').css('display', 'block');
      $('#board-name').removeClass('input');
    }
    else {
      $('#board-name').css('display', 'block');
      $('#board-name-form').css('display', 'none');
      $('#board-name').addClass('input');
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

  $('.lists').sortable({
    cursor: 'grabbing',
    items: '.list',
    handle: '.list-content',
    placeholder: 'list-wrapper list list-sortable-placeholder',
    start: function(e, ui) {
      ui.placeholder.height(ui.item.children().height());
      ui.item.children().addClass('tilt');
      tilt_direction(ui.item.children());
    },
    update: function(e, ui) {
      params = $(this).sortable('serialize');

      $.ajax({
        url: $(this).data('url'),
        type: 'PATCH',
        data: params
      });
    },
    stop: function (event, ui) {
      ui.item.children().removeClass('tilt');
    }
  });

  $('.cards').sortable({
    connectWith: '.cards',
    cursor: 'grabbing',
    placeholder: 'card-sortable-placeholder',
    start: function(e, ui) {
      ui.placeholder.height(ui.item.height());
      ui.item.addClass('tilt');
      tilt_direction(ui.item);
    },
    update: function(e, ui) {
      cardIds = $(this).sortable('serialize');
      sortableId = $(this).attr('id');
      listId = sortableId.split('-').pop();
      params = cardIds.concat('&&list[]=', listId);

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

  $('.card').addClass('ui-widget ui-widget-content ui-helper-clearfix ui-corner-all')
           .find('.card-header')
           .addClass('ui-widget-header ui-corner-all')
           .prepend('<span class="ui-icon ui-icon-minusthick card-toggle"></span>');

  $('.card-toggle').click(function() {
    var icon = $(this);
    icon.toggleClass('ui-icon-minusthick ui-icon-plusthick');
    icon.closest('.card').find('.card-body').toggle();
  });
});
