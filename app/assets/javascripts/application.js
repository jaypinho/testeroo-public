// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

// Improves compatibility between MDL and Turbolinks, as described here: http://stackoverflow.com/questions/32923179/material-design-lite-not-working-with-turbolinks
document.addEventListener('turbolinks:load', function() {
  componentHandler.upgradeDom();
});

function deleteItems() {
  var list_of_items = [];
  for (var i = 0; i < document.querySelectorAll('tbody .mdl-checkbox__input').length; i++) {
    // console.log(document.querySelectorAll('tbody .mdl-checkbox__input')[i].parentElement.parentElement.parentElement);
    if (document.querySelectorAll('tbody .mdl-checkbox__input')[i].checked) {
      list_of_items.push(document.querySelectorAll('tbody .mdl-checkbox__input')[i].parentElement.parentElement.parentElement.dataset.item);
    }
  }

  var input;
  if (document.getElementById('ids')) {
    input = document.getElementById('ids');
  } else {
    input = document.createElement('input');
    input.setAttribute('id', 'ids');
    input.setAttribute('type', 'hidden');
    input.setAttribute('name', 'ids');
    document.getElementById('delete-items-form').appendChild(input);
  }
  input.setAttribute('value', list_of_items);
  document.getElementById('delete-items-form').submit();
}
