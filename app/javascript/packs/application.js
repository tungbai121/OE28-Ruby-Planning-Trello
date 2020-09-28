require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('packs/toastr')
import 'bootstrap'
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
import $ from 'jquery'
global.$ = $
global.jQuery = $
require('packs/board_show')
require('jquery-ui');
