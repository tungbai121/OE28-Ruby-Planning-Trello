$(function() {
  $('body').on('change', '#user_avatar', function() {
    readURL(this);
  });

  function readURL(input) {
    if (input.files && input.files[0]) {
      let reader = new FileReader();

      reader.onload = function(e) {
        $('#avatar-preview').attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  };
});
