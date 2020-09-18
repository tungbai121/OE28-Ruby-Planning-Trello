$(document).ready(function(){
  $('#close-menu').click(function(){
    if($('#close-menu').hasClass('open')){
      $('#board-menu').css('width', '0px');
      $('#board-menu').css('padding', '0px');
      $('#close-menu').removeClass('open');
      $('#open-menu').css('transform', 'translateX(0px)');
    }
  });

  $('#open-menu').click(function(){
    if($('#close-menu').hasClass('open')){
      $('#close-menu').removeClass('open');
      $('#board-menu').css('width', '0px');
      $('#board-menu').css('padding', '0px');
      $('#open-menu').css('transform', 'translateX(0px)');
    } else{
      $('#board-menu').css('width', '300px');
      $('#board-menu').css('padding', '10px 10px');
      $('#close-menu').addClass('open');
      $('#open-menu').css('transform', 'translateX(-300px)');
    }
  });
});
