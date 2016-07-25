// Copyright © Mapotempo, 2013-2014
//
// This file is part of Mapotempo.
//
// Mapotempo is free software. You can redistribute it and/or
// modify since you respect the terms of the GNU Affero General
// Public License as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// Mapotempo is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE.  See the Licenses for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Mapotempo. If not, see:
// <http://www.gnu.org/licenses/agpl.html>
//
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-filestyle
//= require bootstrap-wysihtml5
//= require bootstrap-wysihtml5/locales/fr-FR.js
//= require bootstrap-wysihtml5/locales/en-US.js
//= require bootstrap-datepicker/core.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.fr.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.fr-CH.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.en-GB.js
//= require jquery-ui/sortable
//= require jquery-ui/autocomplete
//= require jquery-ui/dialog
//= require jquery-ui/slider
//= require jquery-tablesorter
//= require jquery-tablesorter/widgets/widget-filter-formatter-html5
//= require jquery-tablesorter/widgets/widget-filter-formatter-jui
//= require jquery-tablesorter/jquery.tablesorter.widgets
//= require jquery-tablesorter/widgets/widget-scroller
//= require jquery-tablesorter/widgets/widget-columnSelector
//= require jquery.simplecolorpicker
//= require jquery.timeentry
//= require i18n
//= require i18n/translations
//= require i18n/translations-setting
//= require leaflet
//= require leaflet.markercluster
//= require leaflet.draw
//= require leaflet_numbered_markers
//= require Leaflet.ControlledBounds
//= require leaflet-pip
//= require leaflet-sidebar
//= require leaflet-hash
//= require leaflet.pattern
//= require Control.Geocoder
//= require Polyline.encoded
//= require mustache
//= require select2
//= require select2_locale_fr
//= require select2_locale_en
//= require bootstrap-select
//= require_tree ../../templates
//= require paloma
//= require leaflet.polylineoffset
//= require pnotify/pnotify.js
//= require pnotify/pnotify.buttons.js
//= require pnotify/pnotify.nonblock.js
//= require pnotify/pnotify.desktop.js
//= require pnotify.init.js
//= require_tree .
// jQuery Turbolinks documentation informs to load all scripts before turbolinks
//= require turbolinks
Turbolinks.enableProgressBar();
// bug in Firefox 40 when printing multi pages with progress bar
window.onbeforeprint = function() {
  Turbolinks.enableProgressBar(false);
};
window.onafterprint = function() {
  Turbolinks.enableProgressBar();
};

$(document).ready(function() {
  startSpinner = function() {
    $('body').addClass('turbolinks_waiting');
  };
  stopSpinner = function() {
    $('body').removeClass('turbolinks_waiting');
  };
  $(document).on("page:fetch", startSpinner);
  $(document).on("page:receive", stopSpinner);

  Paloma.start();
});

$(document).on('page:restore', function() {
  Paloma.start();
});
