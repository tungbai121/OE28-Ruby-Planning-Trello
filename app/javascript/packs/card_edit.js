$(function() {
  $('body').on('change', ".input-box", function() {
    $.ajax({
      url: $(this).data('url'),
      type: "PATCH",
      data: {"checklist": {
        "checked": this.checked
      }}
    });
  });

  $('body').on('change', "#completed", function() {
    $.ajax({
      url: $(this).data('url'),
      type: "PATCH",
      data: {"card": {
        "completed": this.checked
      }}
    });
  });
});
